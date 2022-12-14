//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit

struct FrameUniforms {
    var projectionMatrix: f4x4
    var viewMatrix: f4x4
    static var memorySize: Int {
        return MemoryLayout<FrameUniforms>.stride
    }
} 
    
class TransparentRenderer<
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate, RendererBase {
    
    var pipelineState: MTLRenderPipelineState
    var depthState: MTLDepthStencilState
    var clearTileState: MTLRenderPipelineState
    var resolveState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor
    
    let optimalTileSize = MTLSize(width: 32, height: 16, depth: 1)
    
    let drawProcess: ProcessBase
    var camera: MainCamera<CameraConfig>
    
    override init() {
        
        // MARK: - functions
        let constantValue = MTLFunctionConstantValues()
        let transparencyMethodFragmentFunction = try! ShaderCore.library.makeFunction(name: "OITFragmentFunction_4Layer", constantValues: constantValue)
        let vertexFunction = ShaderCore.library.makeFunction(name: "vertexTransform")
        let resolveFunction = try! ShaderCore.library.makeFunction(name: "OITResolve_4Layer", constantValues: constantValue)
        let clearFunction = try! ShaderCore.library.makeFunction(name: "OITClear_4Layer", constantValues: constantValue)
        
        // MARK: - vertexDescriptor
        vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].offset = 0
        vertexDescriptor.attributes[2].bufferIndex = 2
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = 0
        vertexDescriptor.attributes[3].bufferIndex = 3
        
        vertexDescriptor.attributes[4].format = .float3
        vertexDescriptor.attributes[4].offset = 0
        vertexDescriptor.attributes[4].bufferIndex = 4
        
        vertexDescriptor.layouts[0].stride = f3.memorySize
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        
        vertexDescriptor.layouts[1].stride = f4.memorySize
        vertexDescriptor.layouts[1].stepRate = 1
        vertexDescriptor.layouts[1].stepFunction = .perVertex
        
        vertexDescriptor.layouts[2].stride = f3.memorySize
        vertexDescriptor.layouts[2].stepRate = 1
        vertexDescriptor.layouts[2].stepFunction = .perVertex
        
        vertexDescriptor.layouts[3].stride = f3.memorySize
        vertexDescriptor.layouts[3].stepRate = 1
        vertexDescriptor.layouts[3].stepFunction = .perVertex
        
        vertexDescriptor.layouts[4].stride = f3.memorySize
        vertexDescriptor.layouts[4].stepRate = 1
        vertexDescriptor.layouts[4].stepFunction = .perVertex
        
        // MARK: - render pipeline descriptor
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.sampleCount = 1
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineStateDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
//        pipelineStateDescriptor.colorAttachments[0].writeMask = .none //これはなんだ
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
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = .less
        depthStateDesc.isDepthWriteEnabled = false
        depthState = ShaderCore.device.makeDepthStencilState(descriptor: depthStateDesc)!
        
        
        
        self.drawProcess = DrawProcess.init()
        camera = MainCamera()
        
        super.init()
        
        self.drawProcess.setup()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        
        drawProcess.cameraProcess(camera: camera)
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
        
        
        
        // MARK: - render encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(clearTileState)
        renderEncoder.dispatchThreadsPerTile(optimalTileSize)
        renderEncoder.setCullMode(.none)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // MARK: - set buffer
        
        let frameUniform = [
            FrameUniforms(
                projectionMatrix: camera.perspectiveMatrix,
                viewMatrix: camera.simdMatrix
            )
        ]
        let frameUniformBuffer: MTLBuffer = ShaderCore.device.makeBuffer(
            bytes: frameUniform,
            length: FrameUniforms.memorySize * 1
        )!
        
        renderEncoder.setVertexBuffer(frameUniformBuffer, offset: 0, index: 5)
        renderEncoder.setFragmentBuffer(frameUniformBuffer, offset: 0, index: 5)
        
        // MARK: - draw primitive
        drawProcess.update()
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
