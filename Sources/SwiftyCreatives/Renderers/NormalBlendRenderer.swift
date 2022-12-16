//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import MetalKit

public class NormalBlendRenderer<
    DrawProcess: SketchBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate, RendererBase {
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    var drawProcess: SketchBase
    var camera: MainCamera<CameraConfig>
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    
    var projectionBuf: MTLBuffer
    var viewBuf: MTLBuffer

    public override init() {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "normal_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "normal_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        self.drawProcess = DrawProcess.init()
        
        camera = MainCamera()
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: true)
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        projectionBuf = ShaderCore.device.makeBuffer(length: MemoryLayout<f4x4>.stride)!
        viewBuf = ShaderCore.device.makeBuffer(length: MemoryLayout<f4x4>.stride)!
        
        super.init()
        
        self.drawProcess.setup()
        
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }

    public func draw(in view: MTKView) {
        drawProcess.cameraProcess(camera: camera)
        view.drawableSize = CGSize(
            width: view.frame.size.width * CGFloat(DrawConfig.contentScaleFactor),
            height: view.frame.size.height * CGFloat(DrawConfig.contentScaleFactor)
        )
        camera.setFrame(
            width: Float(view.frame.size.width) * Float(DrawConfig.contentScaleFactor),
            height: Float(view.frame.size.height) * Float(DrawConfig.contentScaleFactor)
        )
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        
        projectionBuf.contents().copyMemory(from: camera.perspectiveMatrix, byteCount: Uniform_ProjectMatrix.memorySize)
        viewBuf.contents().copyMemory(from: camera.mainMatrix, byteCount: Uniform_ViewMatrix.memorySize)
        renderCommandEncoder?.setVertexBuffer(projectionBuf, offset: 0, index: 5)
        renderCommandEncoder?.setVertexBuffer(viewBuf, offset: 0, index: 6)

        renderCommandEncoder?.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(view.bounds.width) * Double(DrawConfig.contentScaleFactor),
                height: Double(view.bounds.height) * Double(DrawConfig.contentScaleFactor),
                znear: -1,
                zfar: 1
            )
        )
        
        drawProcess.update()
        drawProcess.draw(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
}
