//
//  AddRenderer.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#if !os(visionOS)

import MetalKit

public class AddRenderer<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: RendererBase<CameraConfig, DrawConfig> {
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    let renderPipelineState: MTLRenderPipelineState
    public init(sketch: SketchBase) {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "add_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "add_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        super.init(drawProcess: sketch)
        self.drawProcess.setupCamera(camera: camera)
    }
    public override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }
    public override func draw(in view: MTKView) {
        super.draw(in: view)
        guard let _ = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        if DrawConfig.clearOnUpdate {
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
        } else {
            renderPassDescriptor.colorAttachments[0].loadAction = .load
        }
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        drawProcess.preProcess(commandBuffer: commandBuffer!)
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        Self.setDefaultBuffers(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderCommandEncoder?.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [camera.getCameraPos()], length: f3.memorySize)
        renderCommandEncoder?.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderCommandEncoder?.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        drawProcess.beforeDraw(encoder: renderCommandEncoder!)
        drawProcess.updateAndDrawLight(encoder: renderCommandEncoder!)
        drawProcess.update(camera: camera)
        drawProcess.draw(encoder: renderCommandEncoder!)

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
        
        renderCommandEncoder?.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer!)
        
        if cachedTexture == nil || cachedTexture!.width != view.currentDrawable!.texture.width || cachedTexture!.height != view.currentDrawable!.texture.height {
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: view.colorPixelFormat,
                width: view.currentDrawable!.texture.width,
                height: view.currentDrawable!.texture.height,
                mipmapped: false)
            textureDescriptor.usage = [.shaderRead]
            cachedTexture = ShaderCore.device.makeTexture(descriptor: textureDescriptor)
        }
        
        let afterEncoder = commandBuffer!.makeBlitCommandEncoder()!
        afterEncoder.copy(from: renderPassDescriptor.colorAttachments[0].texture!, to: cachedTexture!)
        afterEncoder.copy(from: renderPassDescriptor.colorAttachments[0].texture!, to: view.currentDrawable!.texture)
        afterEncoder.endEncoding()
        commandBuffer!.present(view.currentDrawable!)
        commandBuffer!.commit()
        
        #if canImport(XCTest)
        commandBuffer!.waitUntilCompleted()
        self.drawProcess.afterCommit()
        #endif
    }
}

#endif
