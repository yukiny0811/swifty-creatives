//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

import Metal
import MetalPerformanceShaders

public class BloomPP: PostProcessorBase {
    
    var finalTexture: MTLTexture?
    var addPipelineState: MTLComputePipelineState?
    
    public init() {
        self.addPipelineState = Self.createComputePipelineState(functionName: "bloomAddPostProcess", slowFunctionName: "bloomAddPostProcess", bundle: .module)
        super.init(functionName: "bloomPostProcess", slowFunctionName: "bloomPostProcess", bundle: .module)
    }
    
    public func postProcess(texture: MTLTexture, threshold: Float, intensity: Float) {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture.pixelFormat,
                                                                  width: texture.width,
                                                                  height: texture.height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        savedTexture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        finalTexture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroupCount = MTLSize(
            width: Int(ceilf(Float(texture.width) / Float(threadsPerThreadgroup.width))),
            height: Int(ceilf(Float(texture.height) / Float(threadsPerThreadgroup.height))),
            depth: 1)
        var commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        var commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setBytes([threshold], length: Float.memorySize, index: 0)
        commandEncoder.setTexture(texture, index: 0)
        commandEncoder.setTexture(savedTexture, index: 1)
        commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
        commandBuffer.commit()
        
        commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        let blurFunc = MPSImageGaussianBlur(device: ShaderCore.device, sigma: intensity)
        blurFunc.encode(commandBuffer: commandBuffer, sourceTexture: savedTexture!, destinationTexture: finalTexture!)
        commandBuffer.commit()
        
        commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
        commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        commandEncoder.setComputePipelineState(addPipelineState!)
        commandEncoder.setBytes([threshold], length: Float.memorySize, index: 0)
        commandEncoder.setTexture(texture, index: 0)
        commandEncoder.setTexture(finalTexture, index: 1)
        commandEncoder.setTexture(texture, index: 2)
        commandEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
        commandBuffer.commit()
    }
}
