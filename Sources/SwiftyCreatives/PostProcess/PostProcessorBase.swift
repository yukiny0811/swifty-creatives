//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

import Metal

open class PostProcessorBase {
    
    public var pipelineState: MTLComputePipelineState
    public var savedTexture: MTLTexture?
    public var args: [Float] = [0]
    
    public init(functionName: String, slowFunctionName: String) {
        pipelineState = Self.createComputePipelineState(functionName: functionName, slowFunctionName: slowFunctionName)
    }
    
    private static func createComputePipelineState(functionName: String, slowFunctionName: String) -> MTLComputePipelineState {
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            let function = ShaderCore.library.makeFunction(name: functionName)!
            return try! ShaderCore.device.makeComputePipelineState(function: function)
        default:
            let function = ShaderCore.library.makeFunction(name: slowFunctionName)!
            return try! ShaderCore.device.makeComputePipelineState(function: function)
        }
    }
}
