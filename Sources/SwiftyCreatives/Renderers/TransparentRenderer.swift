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
    
class TransparentRenderer<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate, RendererBase {
    
    var pipelineState: MTLRenderPipelineState
    var depthState: MTLDepthStencilState
    var clearTileState: MTLRenderPipelineState
    var resolveState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor
    
    let optimalTileSize = MTLSize(width: 32, height: 16, depth: 1)
    
    var drawProcess: SketchBase
    var camera: MainCamera<CameraConfig>
    
    public init(sketch: SketchBase) {
        
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
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
        pipelineStateDescriptor.fragmentFunction = transparencyMethodFragmentFunction
        pipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        // MARK: - Tile descriptor
        let tileDesc = MTLTileRenderPipelineDescriptor()
        tileDesc.tileFunction = resolveFunction
        tileDesc.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        tileDesc.threadgroupSizeMatchesTileSize = true
        resolveState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        tileDesc.tileFunction = clearFunction
        clearTileState = try! ShaderCore.device.makeRenderPipelineState(tileDescriptor: tileDesc, options: .argumentInfo, reflection: nil) // FIXME: argumentinfo?
        
        // MARK: - Depth Descriptor
        let depthStateDesc = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: false)
        depthState = ShaderCore.device.makeDepthStencilState(descriptor: depthStateDesc)!
        
        
        self.drawProcess = sketch
        
        camera = MainCamera()
        
        super.init()
        
        self.drawProcess.setupCamera(camera: camera)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        
        view.drawableSize = CGSize(
            width: view.frame.size.width * CGFloat(DrawConfig.contentScaleFactor),
            height: view.frame.size.height * CGFloat(DrawConfig.contentScaleFactor)
        )
        camera.setFrame(
            width: Float(view.frame.size.width) * Float(DrawConfig.contentScaleFactor),
            height: Float(view.frame.size.height) * Float(DrawConfig.contentScaleFactor)
        )
        
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        
        // MARK: - render pass descriptor
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.tileWidth = optimalTileSize.width
        renderPassDescriptor.tileHeight = optimalTileSize.height
        renderPassDescriptor.imageblockSampleLength = resolveState.imageblockSampleLength
        
        if DrawConfig.clearOnUpdate {
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
        } else {
            renderPassDescriptor.colorAttachments[0].loadAction = .load
        }
        
        // MARK: - render encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        Self.setDefaultBuffers(encoder: renderEncoder)
        
        renderEncoder.setRenderPipelineState(clearTileState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        renderEncoder.setCullMode(.none)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // MARK: - set buffer
        
        renderEncoder.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: 4)
        renderEncoder.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: 5)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [camera.getCameraPos()], length: f3.memorySize)
        renderEncoder.setVertexBuffer(cameraPosBuffer, offset: 0, index: 6)
        renderEncoder.setFragmentTexture(AssetUtil.defaultMTLTexture, index: 0)
        
        // MARK: - draw primitive
        drawProcess.beforeDraw(encoder: renderEncoder)
        drawProcess.updateAndDrawLight(encoder: renderEncoder)
        drawProcess.update(camera: camera)
        drawProcess.draw(encoder: renderEncoder)
        
        renderEncoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(view.bounds.width) * Double(DrawConfig.contentScaleFactor),
                height: Double(view.bounds.height) * Double(DrawConfig.contentScaleFactor),
                znear: -1,
                zfar: 1
            )
        )
        
        // MARK: - end encoding
        renderEncoder.setRenderPipelineState(resolveState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        renderEncoder.endEncoding()
        
        // MARK: - commit buffer
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}
