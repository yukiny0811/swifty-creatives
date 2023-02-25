//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import Metal

public enum PostProcessType {
    case plain
    case cornerRadius(Float)
}

public class PostProcessor {
    private var pipelineState: MTLComputePipelineState
    private(set) public var type: PostProcessType
    private(set) public var savedTexture: MTLTexture?
    private var args: [Float] = [0]
    public init(type: PostProcessType) {
        self.type = type
        switch self.type {
        case .plain:
            self.pipelineState = Self.createComputePipelineState(functionName: "plain")
        case .cornerRadius(let radius):
            self.pipelineState = Self.createComputePipelineState(functionName: "cornerRadius")
            args[0] = radius
        }
    }
    
    //true if read_write enabled
    @discardableResult
    public func postProcess(texture: MTLTexture) -> Bool {
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroupCount = MTLSize(
            width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
            height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
            depth: 1)
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(pipelineState)
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            commandEncoder.setTexture(texture, index: 0)
            commandEncoder.setBytes(args, length: Float.memorySize * args.count, index: 0)
            commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
            commandEncoder.endEncoding()
            commandBuffer.commit()
            return true
        default:
            savedTexture = texture
            commandEncoder.setTexture(savedTexture, index: 0)
            commandEncoder.setTexture(texture, index: 1)
            commandEncoder.setBytes(args, length: Float.memorySize * args.count, index: 0)
            commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
            commandEncoder.endEncoding()
            commandBuffer.commit()
            return false
        }
    }
    private static func createComputePipelineState(functionName: String) -> MTLComputePipelineState {
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            let function = ShaderCore.library.makeFunction(name: functionName + "PostProcess")!
            return try! ShaderCore.device.makeComputePipelineState(function: function)
        default:
            let function = ShaderCore.library.makeFunction(name: functionName + "PostProcess_Slow")!
            return try! ShaderCore.device.makeComputePipelineState(function: function)
        }
    }
}
