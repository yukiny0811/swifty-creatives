//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/09.
//

import MetalKit
import EasyMetalShader
import SwiftyCreativesCore

class PhotonMapPipeline {
    
    let calculateRay: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "photonMap_calculateRay")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    
    func encode(objects: [RayTargetObject]) {
        
        let rayOriginTex = EMMetalTexture.create(width: 1000, height: 1000, pixelFormat: .rgba32Float, label: "photonOriginTex")
        
        let staticVertices = objects.flatMap { $0.vertices }
        let objectBuffer = ShaderCore.device.makeBuffer(bytes: staticVertices, length: MemoryLayout<RayTracingVertex>.stride * staticVertices.count)!
        
        let uniform = RayTracingUniform(cameraTransform: .createTransform(0, 10, 0))
        
        let dispatch = EMMetalDispatch()
        dispatch.compute { [weak self] encoder in
            guard let self else { return }
            
            encoder.setTexture(rayOriginTex, index: 1)
            
            encoder.setBuffer(objectBuffer, offset: 0, index: 0)
            encoder.setBytes([uniform], length: MemoryLayout<RayTracingUniform>.stride, index: 1)
            encoder.setBytes([objectBuffer.length / MemoryLayout<RayTracingVertex>.stride], length: Int32.memorySize, index: 2)
            encoder.setBytes([f3(Float.random(in: 0...10000),Float.random(in: 0...10000),Float.random(in: 0...10000))],length: f3.memorySize, index: 3)
        
            encoder.setComputePipelineState(calculateRay)
            let dispatchSize = Self.createDispatchSize(for: calculateRay, width: rayOriginTex.width, height: rayOriginTex.height)
            encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
        }
        dispatch.commit()
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
