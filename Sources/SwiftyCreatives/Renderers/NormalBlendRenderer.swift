//
//  NormalBlendRenderer.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#if !os(visionOS)

import MetalKit

public class NormalBlendRenderer: RendererBase {
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    
    public init(sketch: Sketch, cameraConfig: CameraConfig, drawConfig: DrawConfig) {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "normal_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "normal_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: true)
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        super.init(drawProcess: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
        
        self.drawProcess.setupCamera(camera: camera)
    }

    public override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }

    public override func draw(in view: MTKView) {
        super.draw(in: view)
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        drawProcess.metalDrawableSize = f2(Float(drawable.texture.width), Float(drawable.texture.height))
        
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        drawProcess.preProcess(commandBuffer: commandBuffer!)
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        Self.setDefaultBuffers(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        
        renderCommandEncoder?.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderCommandEncoder?.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [camera.getCameraPos()], length: f3.memorySize)
        renderCommandEncoder?.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderCommandEncoder?.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
        drawProcess.beforeDraw(encoder: renderCommandEncoder!)
        drawProcess.update(camera: camera)
        drawProcess.draw(encoder: renderCommandEncoder!, camera: camera)
        
        renderCommandEncoder?.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(view.bounds.width) * Double(drawConfig.contentScaleFactor),
                height: Double(view.bounds.height) * Double(drawConfig.contentScaleFactor),
                znear: -1,
                zfar: 1
            )
        )
        
        renderCommandEncoder?.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer!)
        
        commandBuffer!.present(view.currentDrawable!)
        commandBuffer!.commit()
        
        #if canImport(XCTest)
        commandBuffer!.waitUntilCompleted()
        self.drawProcess.afterCommit(texture: renderPassDescriptor.colorAttachments[0].texture)
        #endif
        
    }
}

#endif
