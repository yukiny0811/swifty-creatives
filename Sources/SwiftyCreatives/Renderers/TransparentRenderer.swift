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

#if !os(visionOS)
    
class TransparentRenderer: RendererBase {
    
    var pipelineState: MTLRenderPipelineState
    var depthState: MTLDepthStencilState
    var clearTileState: MTLRenderPipelineState
    var resolveState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor
    
    let optimalTileSize = MTLSize(width: 32, height: 16, depth: 1)
    
    public init(sketch: Sketch, cameraConfig: CameraConfig, drawConfig: DrawConfig) {
        
        // MARK: - functions
        let constantValue = MTLFunctionConstantValues()
        let transparencyMethodFragmentFunction = try! ShaderCore.library.makeFunction(name: "OITFragmentFunction_4Layer", constantValues: constantValue)
        let vertexFunction = ShaderCore.library.makeFunction(name: "vertexTransform")
        let resolveFunction = try! ShaderCore.library.makeFunction(name: "OITResolve_4Layer", constantValues: constantValue)
        let clearFunction = try! ShaderCore.library.makeFunction(name: "OITClear_4Layer", constantValues: constantValue)
        
        // MARK: - vertexDescriptor
        vertexDescriptor = Self.createVertexDescriptor()
        
        // MARK: - render pipeline descriptor
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.rasterSampleCount = 1
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
        pipelineStateDescriptor.fragmentFunction = transparencyMethodFragmentFunction
        pipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        // MARK: - Tile descriptor
        let tileDesc = MTLTileRenderPipelineDescriptor()
        tileDesc.tileFunction = resolveFunction
        tileDesc.colorAttachments[0].pixelFormat = .bgra8Unorm
        tileDesc.threadgroupSizeMatchesTileSize = true
        resolveState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        tileDesc.tileFunction = clearFunction
        clearTileState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        // MARK: - Depth Descriptor
        let depthStateDesc = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: false)
        depthState = ShaderCore.device.makeDepthStencilState(descriptor: depthStateDesc)!
        
        super.init(drawProcess: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
        
        self.drawProcess.setupCamera(camera: camera)
    }
    
    override func draw(in view: MTKView) {
        super.draw(in: view)
        
        drawProcess.metalDrawableSize = f2(Float(view.currentDrawable!.texture.width), Float(view.currentDrawable!.texture.height))
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        
        // MARK: - render pass descriptor
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.tileWidth = optimalTileSize.width
        renderPassDescriptor.tileHeight = optimalTileSize.height
        renderPassDescriptor.imageblockSampleLength = resolveState.imageblockSampleLength
        
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        
        drawProcess.preProcess(commandBuffer: commandBuffer)
        
        // MARK: - render encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        Self.setDefaultBuffers(encoder: renderEncoder)
        
        renderEncoder.setRenderPipelineState(clearTileState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        renderEncoder.setCullMode(.none)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // MARK: - set buffer
        
        renderEncoder.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderEncoder.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [camera.getCameraPos()], length: f3.memorySize)
        renderEncoder.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderEncoder.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
        // MARK: - draw primitive
        drawProcess.beforeDraw(encoder: renderEncoder)
        drawProcess.update(camera: camera)
        drawProcess.draw(encoder: renderEncoder)
        
        renderEncoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(view.bounds.width) * Double(drawConfig.contentScaleFactor),
                height: Double(view.bounds.height) * Double(drawConfig.contentScaleFactor),
                znear: -1,
                zfar: 1
            )
        )
        
        // MARK: - end encoding
        renderEncoder.setRenderPipelineState(resolveState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        
        renderEncoder.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer)
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        #if canImport(XCTest)
        self.drawProcess.afterCommit(texture: renderPassDescriptor.colorAttachments[0].texture)
        #endif
    }
}

#endif
