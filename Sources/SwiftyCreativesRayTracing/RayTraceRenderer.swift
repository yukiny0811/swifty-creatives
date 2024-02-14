//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/07.
//

import MetalKit
import SwiftyCreatives
import EasyMetalShader

public class RayTraceRenderer: NSObject, MTKViewDelegate {
    
    var drawProcess: RayTraceSketch
    var uniform: RayTracingUniform
    
    var isExecuting = false
    
    let rayTrace: MTLComputePipelineState = {
        let function = ShaderCore.rayTracingShaderLibrary.makeFunction(name: "rayTrace")!
        let computeDesc = MTLComputePipelineDescriptor()
        computeDesc.computeFunction = function
        computeDesc.maxCallStackDepth = 100
        let state = try! SwiftyCreatives.ShaderCore.device.makeComputePipelineState(descriptor: computeDesc, options: [], reflection: nil)
        return state
    }()
    
    public init(drawProcess: RayTraceSketch) {
        self.drawProcess = drawProcess
        self.uniform = .init(cameraTransform: .createIdentity())
    }
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    public func draw(in view: MTKView) {
        
        if isExecuting { return }
        
        view.drawableSize = CGSize(
            width: view.frame.size.width * 2,
            height: view.frame.size.height * 2
        )
        guard let drawable = view.currentDrawable else {
            return
        }
        drawProcess.clearObjects()
        drawProcess.updateUniform(uniform: &uniform)
        drawProcess.draw()
        
        var accelerationStructure: MTLAccelerationStructure! = nil
        
        let dispatch = EMMetalDispatch()
        dispatch.custom { [self] commandBuffer in
            
            // create descriptor
            let accelerationStructureDescriptor = MTLPrimitiveAccelerationStructureDescriptor()
            accelerationStructureDescriptor.geometryDescriptors = []
            for geometry in drawProcess.objects {
                let vertices = geometry.vertices.flatMap {
                    [ $0.v1, $0.v2, $0.v3 ]
                }
                let triangles = geometry.vertices.map {
                    RayTraceTriangle(
                        positions: ($0.v1, $0.v2, $0.v3),
                        normal: $0.normal,
                        colors: ($0.color, $0.color, $0.color),
                        uvs: ($0.uv1, $0.uv2, $0.uv3),
                        roughness: $0.roughness,
                        metallic: $0.metallic,
                        isMetal: $0.isMetal
                    )
                }
                let geometryDescriptor = MTLAccelerationStructureTriangleGeometryDescriptor()
                geometryDescriptor.vertexBuffer = SwiftyCreatives.ShaderCore.device.makeBuffer(
                    bytes: vertices,
                    length: f3.memorySize * vertices.count
                )
                geometryDescriptor.vertexFormat = .float3
                geometryDescriptor.vertexBufferOffset = 0
                geometryDescriptor.vertexStride = f3.memorySize
                geometryDescriptor.triangleCount = vertices.count / 3
                geometryDescriptor.primitiveDataBuffer = SwiftyCreatives.ShaderCore.device.makeBuffer(
                    bytes: triangles,
                    length: MemoryLayout<RayTraceTriangle>.stride * triangles.count
                )
                geometryDescriptor.primitiveDataStride = MemoryLayout<RayTraceTriangle>.stride
                geometryDescriptor.primitiveDataElementSize = MemoryLayout<RayTraceTriangle>.stride
                accelerationStructureDescriptor.geometryDescriptors?.append(geometryDescriptor)
            }
            
            // allocate storage
            let sizes = SwiftyCreatives.ShaderCore.device.accelerationStructureSizes(descriptor: accelerationStructureDescriptor)
            accelerationStructure = SwiftyCreatives.ShaderCore.device.makeAccelerationStructure(size: sizes.accelerationStructureSize)!
            let scratchBuffer = SwiftyCreatives.ShaderCore.device.makeBuffer(length: sizes.buildScratchBufferSize, options: .storageModePrivate)!
            
            let accelerationEncoder = commandBuffer.makeAccelerationStructureCommandEncoder()!
            accelerationEncoder.build(
                accelerationStructure: accelerationStructure,
                descriptor: accelerationStructureDescriptor,
                scratchBuffer: scratchBuffer,
                scratchBufferOffset: 0
            )
            accelerationEncoder.endEncoding()
        }
        
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: true) { _ in }
        
        dispatch.compute { [weak self] encoder in
            guard let self else { return }
            
            encoder.setTexture(drawable.texture, index: 0)
            
            encoder.setBytes([uniform], length: MemoryLayout<RayTracingUniform>.stride, index: 1)
            encoder.setAccelerationStructure(accelerationStructure, bufferIndex: 2)
            encoder.setBytes([f3(Float.random(in: 0...300),Float.random(in: 0...300),Float.random(in: 0...300))],length: f3.memorySize, index: 3)
            encoder.setBytes([drawProcess.rayTraceConfig.bounceCount], length: Int32.memorySize, index: 4)
            encoder.setBytes([drawProcess.rayTraceConfig.sampleCount], length: Int32.memorySize, index: 5)
            encoder.setBytes(drawProcess.pointLights, length: MemoryLayout<PointLight>.stride * drawProcess.pointLights.count, index: 6)
            encoder.setBytes([drawProcess.pointLights.count], length: Int32.memorySize, index: 7)
            
            encoder.setComputePipelineState(rayTrace)
            let dispatchSize = Self.createDispatchSize(for: rayTrace, width: drawable.texture.width, height: drawable.texture.height)
            encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
        }
        
        //commit
        dispatch.present(drawable: drawable)
        dispatch.custom { cb in
            cb.commit()
            self.isExecuting = true
            cb.waitUntilCompleted()
            self.isExecuting = false
        }
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