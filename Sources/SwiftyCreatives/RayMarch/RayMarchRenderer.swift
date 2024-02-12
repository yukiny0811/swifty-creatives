//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

import MetalKit
import SwiftyCreativesCore
import EasyMetalShader

public class RayMarchRenderer: NSObject, MTKViewDelegate {
    
    var sketch: RayMarchSketch
    var uniform: RayMarchUniform
    
    let rayMarch: MTLComputePipelineState = {
        let function = ShaderCore.library.makeFunction(name: "rayMarch")!
        let state = try! ShaderCore.device.makeComputePipelineState(function: function)
        return state
    }()
    
    public init(sketch: RayMarchSketch) {
        self.sketch = sketch
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
        sketch.elapsedTime = Float(Date().timeIntervalSince(sketch.startDate))
        sketch.deltaTime = Float(Date().timeIntervalSince(sketch.lastFrameDate))
        sketch.lastFrameDate = Date()
        sketch.frameRate = 1.0 / sketch.deltaTime
        
        sketch.clearObjects()
        sketch.updateUniform(uniform: &uniform)
        sketch.draw()
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setTexture(drawable.texture, index: 0)
        encoder.setBytes(sketch.objects, length: MemoryLayout<RayMarchObject>.stride * sketch.objects.count, index: 0)
        encoder.setBytes([uniform], length: MemoryLayout<RayMarchUniform>.stride, index: 1)
        encoder.setBytes([sketch.objects.count], length: MemoryLayout<Int32>.stride, index: 2)
        encoder.setBytes([sketch.marchCount], length: MemoryLayout<Int32>.stride, index: 3)
        
        encoder.setComputePipelineState(rayMarch)
        let dispatchSize = Self.createDispatchSize(for: rayMarch, width: drawable.texture.width, height: drawable.texture.height)
        encoder.dispatchThreadgroups(dispatchSize.threadGroupCount, threadsPerThreadgroup: dispatchSize.threadsPerThreadGroup)
        
        encoder.endEncoding()
        
        //commit
        commandBuffer.present(drawable)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
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
