//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/07.
//

import MetalKit
import SwiftyCreativesCore
import EasyMetalShader

public class RayTraceRenderer: NSObject, MTKViewDelegate {
    
    var drawProcess: RayTraceSketch
    var uniform: RayTracingUniform
    var sampleCount: Int32 = 10
    
    var rayOriginTex = EMMetalTexture.create(width: 1, height: 1, pixelFormat: .rgba32Float, label: "rayOriginTex")
    var rayDirectionTex = EMMetalTexture.create(width: 1, height:1, pixelFormat: .rgba32Float, label: "rayDirectionTex")
    var rayColorTex = EMMetalTexture.create(width: 1, height: 1, pixelFormat: .rgba32Float, label: "rayColorTex")
    var rayParameterTex = EMMetalTexture.create(width: 1, height: 1, pixelFormat: .rgba32Float, label: "rayParameterTex")
    var sampleSumTex = EMMetalTexture.create(width: 1, height: 1, pixelFormat: .rgba32Float, label: "sampleSumTex")
    
    let initRay: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "rayTrace_initRay")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    let calculateRay: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "rayTrace_calculateRay")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    let addSample: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "rayTrace_addSample")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    let drawRay: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "rayTrace_drawRay")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    
    public init(drawProcess: RayTraceSketch) {
        self.drawProcess = drawProcess
        self.uniform = .init(cameraTransform: .createIdentity())
    }
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    public func draw(in view: MTKView) {
        view.drawableSize = CGSize(
            width: view.frame.size.width * 3,
            height: view.frame.size.height * 3
        )
        guard let drawable = view.currentDrawable else {
            return
        }
        if rayOriginTex.width != drawable.texture.width || rayOriginTex.height != drawable.texture.height {
            recreateTexture(drawable: drawable)
        }
        drawProcess.clearObjects()
        drawProcess.updateUniform(uniform: &uniform)
        drawProcess.draw()
        let vertices = drawProcess.objects.flatMap { $0.vertices }
        let vertexBuffer = ShaderCore.device.makeBuffer(bytes: vertices, length: MemoryLayout<RayTracingVertex>.stride * vertices.count)
        
        let dispatch = EMMetalDispatch()
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: true) { _ in }
        dispatch.render(renderTargetTexture: sampleSumTex, needsClear: true) { _ in }
        
        for _ in 0..<sampleCount {
            dispatch.compute { [weak self] encoder in
                guard let self else { return }
                encoder.setComputePipelineState(initRay)
                encoder.setTexture(rayOriginTex, index: 1)
                encoder.setTexture(rayDirectionTex, index: 2)
                encoder.setTexture(rayColorTex, index: 3)
                encoder.setTexture(rayParameterTex, index: 4)
                encoder.setBytes([uniform], length: MemoryLayout<RayTracingUniform>.stride, index: 1)
                let dispatchSize = Self.createDispatchSize(for: initRay, width: rayOriginTex.width, height: rayOriginTex.height)
                encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
            }
            dispatch.compute { [weak self] encoder in
                guard let self else { return }
                encoder.setComputePipelineState(calculateRay)
                encoder.setTexture(rayOriginTex, index: 1)
                encoder.setTexture(rayDirectionTex, index: 2)
                encoder.setTexture(rayColorTex, index: 3)
                encoder.setTexture(rayParameterTex, index: 4)
                encoder.setBuffer(vertexBuffer, offset: 0, index: 0)
                encoder.setBytes([uniform], length: MemoryLayout<RayTracingUniform>.stride, index: 1)
                encoder.setBytes([vertices.count], length: Int32.memorySize, index: 2)
                encoder.setBytes(
                    [f3(
                        Float.random(in: 0...10000),
                        Float.random(in: 0...10000),
                        Float.random(in: 0...10000)
                    )],
                    length: f3.memorySize,
                    index: 3
                )
                let dispatchSize = Self.createDispatchSize(for: calculateRay, width: rayOriginTex.width, height: rayOriginTex.height)
                encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
            }
            dispatch.compute { [weak self] encoder in
                guard let self else { return }
                encoder.setComputePipelineState(addSample)
                encoder.setTexture(rayColorTex, index: 3)
                encoder.setTexture(sampleSumTex, index: 5)
                let dispatchSize = Self.createDispatchSize(for: addSample, width: rayOriginTex.width, height: rayOriginTex.height)
                encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
            }
            dispatch.compute { [weak self] encoder in
                guard let self else { return }
                encoder.setComputePipelineState(drawRay)
                encoder.setTexture(drawable.texture, index: 0)
                encoder.setTexture(sampleSumTex, index: 5)
                encoder.setBytes([sampleCount], length: Int32.memorySize, index: 4)
                let dispatchSize = Self.createDispatchSize(for: drawRay, width: rayOriginTex.width, height: rayOriginTex.height)
                encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
            }
        }
        
        //commit
        dispatch.present(drawable: drawable)
        dispatch.commit()
    }
    
    func recreateTexture(drawable: CAMetalDrawable) {
        rayOriginTex = EMMetalTexture.create(width: drawable.texture.width, height: drawable.texture.height, pixelFormat: .rgba32Float, label: "rayOriginTex")
        rayDirectionTex = EMMetalTexture.create(width: drawable.texture.width, height: drawable.texture.height, pixelFormat: .rgba32Float, label: "rayDirectionTex")
        rayColorTex = EMMetalTexture.create(width: drawable.texture.width, height: drawable.texture.height, pixelFormat: .rgba32Float, label: "rayColorTex")
        rayParameterTex = EMMetalTexture.create(width: drawable.texture.width, height: drawable.texture.height, pixelFormat: .rgba32Float, label: "rayParameterTex")
        sampleSumTex = EMMetalTexture.create(width: drawable.texture.width, height: drawable.texture.height, pixelFormat: .rgba32Float, label: "sampleSumTex")
    }
    
    public static func createDispatchSize(
        for pipe: MTLComputePipelineState,
        width: Int,
        height: Int
    ) -> (threadGroupCount: MTLSize, threadsPerThreadGroup: MTLSize) {
        let maxTotalThreadsPerThreadgroup = pipe.maxTotalThreadsPerThreadgroup
        let threadExecutionWidth = pipe.threadExecutionWidth
        let threadsPerThreadgroup = MTLSize(
            width: threadExecutionWidth,
            height: maxTotalThreadsPerThreadgroup / threadExecutionWidth,
            depth: 1
        )
        let threadGroupCount = MTLSize(
            width: width / threadsPerThreadgroup.width+1,
            height: height / threadsPerThreadgroup.height+1,
            depth: 1
        )
        return (threadGroupCount, threadsPerThreadgroup)
    }
}
