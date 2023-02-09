//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import MetalKit

public class AddRenderer<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate, RendererBase {
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    var drawProcess: SketchBase
    var camera: MainCamera<CameraConfig>
    let renderPipelineState: MTLRenderPipelineState

    public init(sketch: SketchBase) {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "add_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "add_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        
        self.drawProcess = sketch
        
        camera = MainCamera()
        
        super.init()
        
        self.drawProcess.setupCamera(camera: camera)
        
        
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }

    public func draw(in view: MTKView) {
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
        
        if DrawConfig.clearOnUpdate {
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
        } else {
            renderPassDescriptor.colorAttachments[0].loadAction = .load
        }
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        Self.setDefaultBuffers(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: 4)
        renderCommandEncoder?.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: 5)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [camera.getCameraPos()], length: f3.memorySize)
        renderCommandEncoder?.setVertexBuffer(cameraPosBuffer, offset: 0, index: 6)
        renderCommandEncoder?.setFragmentTexture(AssetUtil.defaultMTLTexture, index: 0)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)

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
        
        drawProcess.beforeDraw(encoder: renderCommandEncoder!)
        drawProcess.updateAndDrawLight(encoder: renderCommandEncoder!)
        drawProcess.update(camera: camera)
        drawProcess.draw(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
