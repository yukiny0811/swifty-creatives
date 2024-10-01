//
//  File.swift
//  SwiftyCreatives
//
//  Created by Yuki Kuwashima on 2024/09/30.
//

#if !os(visionOS)

import MetalKit

public class AdvancedRenderer: NSObject, MTKViewDelegate {

    var camera: MainCamera
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    let drawProcess: AdvancedSketch

    public init(_ sketch: AdvancedSketch, cameraConfig: CameraConfig) {
        self.drawProcess = sketch
        self.camera = MainCamera(config: cameraConfig)
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true

        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "advanced_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "advanced_fragment")

        renderPipelineDescriptor.vertexDescriptor = RenderCore.sharedVertexDescriptor

        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: true)
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        self.drawProcess.setupCamera(camera: self.camera)
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }
    public func draw(in view: MTKView) {
        view.drawableSize = CGSize(
            width: view.frame.size.width * 1,
            height: view.frame.size.height * 1
        )
        camera.setFrame(
            width: Float(view.frame.size.width) * 1,
            height: Float(view.frame.size.height) * 1
        )
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }

        renderPassDescriptor.colorAttachments[0].loadAction = .clear

        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!

        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setDepthStencilState(depthStencilState)
        renderCommandEncoder.setVertexBytes(camera.perspectiveMatrix, length: f4x4.memorySize, index: 13)
        renderCommandEncoder.setVertexBytes(camera.mainMatrix, length: f4x4.memorySize, index: 14)
        renderCommandEncoder.setVertexBytes([camera.getCameraPos()], length: f3.memorySize, index: 15)
        renderCommandEncoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: Double(view.bounds.width) * 1,
                height: Double(view.bounds.height) * 1,
                znear: -1,
                zfar: 1
            )
        )
        drawProcess.draw(encoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()

        drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer)

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
}

#endif
