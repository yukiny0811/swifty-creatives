//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Combine
import CoreImage
import MetalKit
import GLKit

public class Renderer<
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase
>: NSObject, MTKViewDelegate {
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexMemorySize: Int
    let vertexDescriptor: MTLVertexDescriptor
    let drawProcess: ProcessBase
    let camera: MainCamera<CameraConfig>
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState

    public override init() {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
// https://developer.apple.com/documentation/metal/mtlrenderpipelinecolorattachmentdescriptor
//        renderPipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
//        renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
//        renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
//        renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
//        renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .one
//        renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .zero
        renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .zero
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "test_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "test_fragment")
        
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        vertexMemorySize = MemoryLayout<Vertex>.stride
        
        vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.size
        
        vertexDescriptor.attributes[2].format = .float4
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = MemoryLayout<simd_float3>.size + MemoryLayout<simd_float4>.size * 1
        
        vertexDescriptor.attributes[3].format = .float4
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = MemoryLayout<simd_float3>.size + (MemoryLayout<simd_float4>.size * 2)
        
        vertexDescriptor.attributes[4].format = .float4
        vertexDescriptor.attributes[4].bufferIndex = 0
        vertexDescriptor.attributes[4].offset = MemoryLayout<simd_float3>.size + (MemoryLayout<simd_float4>.size * 3)
        
        vertexDescriptor.attributes[5].format = .float4
        vertexDescriptor.attributes[5].bufferIndex = 0
        vertexDescriptor.attributes[5].offset = MemoryLayout<simd_float3>.size + (MemoryLayout<simd_float4>.size * 4)
        
        vertexDescriptor.layouts[0].stride = vertexMemorySize
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        self.drawProcess = DrawProcess.init()
        
        camera = MainCamera()
        let depthStencilDescriptor: MTLDepthStencilDescriptor
        depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        super.init()
        
        self.drawProcess.setup()
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard view.frame.size != size else {
            return
        }
    }

    public func draw(in view: MTKView) {
//        let date = Date()
        view.drawableSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height * 3)
        camera.setFrame(width: Float(view.frame.size.width * 3), height: Float(view.frame.size.height) * 3)
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder?.setDepthClipMode(.clip)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)

        let vertexUniform = [
            VertexUniform(
                mat: camera.perspectiveMatrix * camera.simdMatrix
            )
        ]

        let vertexUniformBuffer = ShaderCore.device.makeBuffer(
            bytes: vertexUniform,
            length: MemoryLayout<VertexUniform>.stride * vertexUniform.count
        )
        renderCommandEncoder?.setVertexBuffer(vertexUniformBuffer, offset: 0, index: 1)
        
        renderCommandEncoder?.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: view.bounds.width * 3,
                height: view.bounds.height * 3,
                znear: -1,
                zfar: 1
            )
        )
        
        //--------
        
        drawProcess.draw(
            encoder: renderCommandEncoder!
        )
        
        //--------
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()

//        commandBuffer?.waitUntilCompleted()
//        print("elapsed: \(Date().timeIntervalSince(date))")
    }
}
