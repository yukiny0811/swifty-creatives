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
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate {
    
    var latestDate = Date()
    var sumFrameRate: [Float] = [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
    
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
        
        DrawConfig.blendMode.setMode(descsriptor: renderPipelineDescriptor)
        
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
        
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = MemoryLayout<simd_float3>.size + MemoryLayout<simd_float4>.size
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = MemoryLayout<simd_float3>.size + MemoryLayout<simd_float4>.size + (MemoryLayout<simd_float3>.size * 1)
        
        vertexDescriptor.attributes[4].format = .float3
        vertexDescriptor.attributes[4].bufferIndex = 0
        vertexDescriptor.attributes[4].offset = MemoryLayout<simd_float3>.size + MemoryLayout<simd_float4>.size + (MemoryLayout<simd_float3>.size * 2)
        
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

//        sumFrameRate.remove(at: 0)
//        sumFrameRate.append(Float(1.0 / Date().timeIntervalSince(latestDate)))
//        print("framerate: \(sumFrameRate.reduce(0, +) / Float(sumFrameRate.count))")
//        
//        latestDate = Date()
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
        
        // -- 0.00015
        
        let vertexUniform = [
            VertexUniform(
                mat: camera.combinedMatrix
            )
        ]
        
        let vertexUniformBuffer: MTLBuffer = ShaderCore.device.makeBuffer(
            bytes: vertexUniform,
            length: MemoryLayout<VertexUniform>.stride * vertexUniform.count
        )!
        
        let parallelEncoder = commandBuffer?.makeParallelRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        let renderCommandEncoder = parallelEncoder?.makeRenderCommandEncoder()
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
//        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        
        renderCommandEncoder?.setVertexBuffer(vertexUniformBuffer, offset: 0, index: 1)

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
        
        // -- 0.0006

        //--------
        drawProcess.update()
        drawProcess.draw(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        parallelEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        //--------
        
        
    }
}

