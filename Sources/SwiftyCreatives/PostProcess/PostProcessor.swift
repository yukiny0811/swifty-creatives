//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import Metal

open class PostProcessor: PostProcessorBase {
    
    public override init(functionName: String, slowFunctionName: String, bundle: Bundle) {
        super.init(functionName: functionName, slowFunctionName: slowFunctionName, bundle: bundle)
    }
    
    //true if read_write enabled
    @discardableResult
    public func postProcess(commandBuffer: MTLCommandBuffer, texture: MTLTexture) -> Bool {
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroupCount = MTLSize(
            width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
            height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
            depth: 1)
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(pipelineState)
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            commandEncoder.setTexture(texture, index: 0)
            commandEncoder.setBytes(args, length: Float.memorySize * args.count, index: 0)
            commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
            commandEncoder.endEncoding()
            return true
        default:
            savedTexture = texture
            commandEncoder.setTexture(savedTexture, index: 0)
            commandEncoder.setTexture(texture, index: 1)
            commandEncoder.setBytes(args, length: Float.memorySize * args.count, index: 0)
            commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
            commandEncoder.endEncoding()
            return false
        }
    }
}
