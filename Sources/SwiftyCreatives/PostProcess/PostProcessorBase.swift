//
//  PostProcessorBase.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

import Metal

open class PostProcessorBase {
    
    public var pipelineState: MTLComputePipelineState
    public var savedTexture: MTLTexture?
    public var args: [Float] = [0]
    
    public init(functionName: String, slowFunctionName: String, bundle: Bundle) {
        pipelineState = Self.createComputePipelineState(functionName: functionName, slowFunctionName: slowFunctionName, bundle: bundle)
    }
    
    public func setArgs(args: [Float]) -> Self {
        self.args = args
        return self
    }
    
    public static func createComputePipelineState(functionName: String, slowFunctionName: String, bundle: Bundle) -> MTLComputePipelineState {
        switch ShaderCore.device.readWriteTextureSupport {
        case .tier1, .tier2:
            switch bundle {
            case .module:
                let function = ShaderCore.library.makeFunction(name: functionName)!
                return try! ShaderCore.device.makeComputePipelineState(function: function)
            default:
                guard let function = ShaderCore.mainLibrary?.makeFunction(name: functionName)! else {
                    fatalError("could not make MTLFunction \(functionName)")
                }
                return try! ShaderCore.device.makeComputePipelineState(function: function)
            }
        default:
            switch bundle {
            case .module:
                let function = ShaderCore.library.makeFunction(name: slowFunctionName)!
                return try! ShaderCore.device.makeComputePipelineState(function: function)
            default:
                guard let function = ShaderCore.mainLibrary?.makeFunction(name: slowFunctionName)! else {
                    fatalError("could not make MTLFunction \(functionName)")
                }
                return try! ShaderCore.device.makeComputePipelineState(function: function)
            }
        }
    }
}
