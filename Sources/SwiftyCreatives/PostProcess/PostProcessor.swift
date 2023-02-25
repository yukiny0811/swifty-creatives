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
    private var args: [Float] = [0]
    public init(type: PostProcessType) {
        self.type = type
        switch self.type {
        case .plain:
            self.pipelineState = Self.createComputePipelineState(functionName: "plainPostProcess")
        case .cornerRadius(let radius):
            self.pipelineState = Self.createComputePipelineState(functionName: "cornerRadiusPostProcess")
            args[0] = radius
        }
    }
    
    //true if success
    @discardableResult
    public func postProcess(texture: MTLTexture) -> Bool {
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
            let threadGroupCount = MTLSize(
                width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
                height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
                depth: 1)
            let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
            let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
            commandEncoder.setComputePipelineState(pipelineState)
            commandEncoder.setTexture(texture, index: 0)
            commandEncoder.setBytes(args, length: Float.memorySize * args.count, index: 0)
            commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
            commandEncoder.endEncoding()
            commandBuffer.commit()
            return true
        default:
            return false
        }
    }
    private static func createComputePipelineState(functionName: String) -> MTLComputePipelineState {
        let function = ShaderCore.library.makeFunction(name: functionName)!
        return try! ShaderCore.device.makeComputePipelineState(function: function)
    }
}
