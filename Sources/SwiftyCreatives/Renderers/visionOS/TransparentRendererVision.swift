//
//  TransparentRenderer.swift
//
//  Original source code from Apple Inc. https://developer.apple.com/videos/play/tech-talks/605/
//  Modified by Yuki Kuwashima on 2022/12/14.
//
//  Copyright © 2017 Apple Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import MetalKit

#if os(visionOS)

import CompositorServices
import Spatial
    
class TransparentRendererVision: RendererBase {
    
    var pipelineState: MTLRenderPipelineState
    var depthState: MTLDepthStencilState
    var clearTileState: MTLRenderPipelineState
    var resolveState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor
    
    let optimalTileSize = MTLSize(width: 32, height: 16, depth: 1)
    
    public override init(sketch: Sketch, layerRenderer: LayerRenderer) {
        
        // MARK: - functions
        let constantValue = MTLFunctionConstantValues()
        let transparencyMethodFragmentFunction = try! ShaderCore.library.makeFunction(name: "OITFragmentFunction_4Layer", constantValues: constantValue)
        let vertexFunction = ShaderCore.library.makeFunction(name: "vertexTransform_vision")
        let resolveFunction = try! ShaderCore.library.makeFunction(name: "OITResolve_4Layer", constantValues: constantValue)
        let clearFunction = try! ShaderCore.library.makeFunction(name: "OITClear_4Layer", constantValues: constantValue)
        
        // MARK: - vertexDescriptor
        vertexDescriptor = Self.createVertexDescriptor()
        
        // MARK: - render pipeline descriptor
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.rasterSampleCount = 1
        pipelineStateDescriptor.depthAttachmentPixelFormat = layerRenderer.configuration.depthFormat
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = layerRenderer.configuration.colorFormat
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
        pipelineStateDescriptor.fragmentFunction = transparencyMethodFragmentFunction
        pipelineStateDescriptor.maxVertexAmplificationCount = layerRenderer.properties.viewCount
        pipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        // MARK: - Tile descriptor
        let tileDesc = MTLTileRenderPipelineDescriptor()
        tileDesc.tileFunction = resolveFunction
        tileDesc.colorAttachments[0].pixelFormat = layerRenderer.configuration.colorFormat
        tileDesc.threadgroupSizeMatchesTileSize = true
        resolveState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        tileDesc.tileFunction = clearFunction
        clearTileState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        // MARK: - Depth Descriptor
        let depthStateDesc = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: false)
        depthState = ShaderCore.device.makeDepthStencilState(descriptor: depthStateDesc)!
        
        super.init(sketch: sketch, layerRenderer: layerRenderer)
    }
    
    override func renderFrame() {
        guard let frame = layerRenderer.queryNextFrame() else { return }
        
        frame.startUpdate()
        
        frame.endUpdate()
        
        guard let timing = frame.predictTiming() else { return }
        LayerRenderer.Clock().wait(until: timing.optimalInputTime)
        guard let drawable = frame.queryDrawable() else { return }
        frame.startSubmission()
        let time = LayerRenderer.Clock.Instant.epoch.duration(to: drawable.frameTiming.presentationTime).timeInterval
        let deviceAnchor = worldTracking.queryDeviceAnchor(atTimestamp: time)
        drawable.deviceAnchor = deviceAnchor
        
        // cb
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.colorTextures[0]
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDescriptor.depthAttachment.texture = drawable.depthTextures[0]
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .store
        renderPassDescriptor.depthAttachment.clearDepth = 0.0
        renderPassDescriptor.rasterizationRateMap = drawable.rasterizationRateMaps.first
        renderPassDescriptor.tileWidth = optimalTileSize.width
        renderPassDescriptor.tileHeight = optimalTileSize.height
        renderPassDescriptor.imageblockSampleLength = resolveState.imageblockSampleLength
        if layerRenderer.configuration.layout == .layered {
            renderPassDescriptor.renderTargetArrayLength = drawable.views.count
        }
        
        drawProcess.preProcess(commandBuffer: commandBuffer)
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        Self.setDefaultBuffers(encoder: renderEncoder)
        
        renderEncoder.setRenderPipelineState(clearTileState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        renderEncoder.setCullMode(.none)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        let simdDeviceAnchor = deviceAnchor?.originFromAnchorTransform ?? matrix_identity_float4x4
        
        let viewMatrixs = drawable.views.map { (simdDeviceAnchor * $0.transform).inverse }
        let projectionTemps = drawable.views.map {
            ProjectiveTransform3D(
                leftTangent: Double($0.tangents[0]),
                rightTangent: Double($0.tangents[1]),
                topTangent: Double($0.tangents[2]),
                bottomTangent: Double($0.tangents[3]),
                nearZ: Double(drawable.depthRange.y),
                farZ: Double(drawable.depthRange.x),
                reverseZ: true
            )
        }
        let projections = projectionTemps.map { matrix_float4x4.init($0) }
        
        renderEncoder.setVertexBytes(projections, length: f4x4.memorySize * projections.count, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderEncoder.setVertexBytes(viewMatrixs, length: f4x4.memorySize * viewMatrixs.count, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let viewports = drawable.views.map { $0.textureMap.viewport }
        renderEncoder.setViewports(viewports)
        
        if drawable.views.count > 1 {
            var viewMappings = (0..<drawable.views.count).map {
                MTLVertexAmplificationViewMapping(viewportArrayIndexOffset: UInt32($0),
                                                  renderTargetArrayIndexOffset: UInt32($0))
            }
            renderEncoder.setVertexAmplificationCount(viewports.count, viewMappings: &viewMappings)
        }
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [f3(0, 0, 0)], length: f3.memorySize)
        renderEncoder.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderEncoder.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
        drawProcess.beforeDraw(encoder: renderEncoder)
        drawProcess.update()
        drawProcess.draw(encoder: renderEncoder)
        
        renderEncoder.setRenderPipelineState(resolveState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        
        renderEncoder.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer)
        
        drawable.encodePresent(commandBuffer: commandBuffer)
        commandBuffer.commit()
        
        commandBuffer.waitUntilCompleted()
        self.drawProcess.afterCommit(texture: renderPassDescriptor.colorAttachments[0].texture)
        
        frame.endSubmission()
    }
}

#endif
