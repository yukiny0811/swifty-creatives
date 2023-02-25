//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import Metal

public class TextPostProcessor {
    private var pipelineState: MTLComputePipelineState
    private(set) public var savedTexture: MTLTexture?
    public init() {
        self.pipelineState = Self.createComputePipelineState(functionName: "textColor")
    }
    
    //true if read_write enabled
    public func postProcessColor(originalTexture: MTLTexture, texture: MTLTexture, color: f4) {
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroupCount = MTLSize(
            width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
            height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
            depth: 1)
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setBytes([color], length: f4.memorySize, index: 0)
        commandEncoder.setTexture(originalTexture, index: 0)
        commandEncoder.setTexture(texture, index: 1)
        commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
        commandBuffer.commit()
    }
    
    private static func createComputePipelineState(functionName: String) -> MTLComputePipelineState {
        let function = ShaderCore.library.makeFunction(name: functionName + "PostProcess")!
        return try! ShaderCore.device.makeComputePipelineState(function: function)
    }
}
