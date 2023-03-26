//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import Metal

public class TextPostProcessor: PostProcessorBase {
    
    public init() {
        super.init(functionName: "textColorPostProcess", slowFunctionName: "textColorPostProcess", bundle: .module)
    }
    
    public func postProcessColor(commandBuffer: MTLCommandBuffer, originalTexture: MTLTexture, texture: MTLTexture, color: f4) {
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroupCount = MTLSize(
            width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
            height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
            depth: 1)
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setBytes([color], length: f4.memorySize, index: 0)
        commandEncoder.setTexture(originalTexture, index: 0)
        commandEncoder.setTexture(texture, index: 1)
        commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
    }
}
