//
//  RendererBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit
import simd

protocol RendererBase: MTKViewDelegate {
    associatedtype Camera: MainCameraBase
    var camera: Camera { get }
    var drawProcess: any SketchBase { get set }
}

extension RendererBase {
    static func createVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 11
        
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].offset = 0
        vertexDescriptor.attributes[2].bufferIndex = 12
        
        vertexDescriptor.layouts[0].stride = 16
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        
        vertexDescriptor.layouts[11].stride = 8
        vertexDescriptor.layouts[11].stepRate = 1
        vertexDescriptor.layouts[11].stepFunction = .perVertex
        
        vertexDescriptor.layouts[12].stride = 16
        vertexDescriptor.layouts[12].stepRate = 1
        vertexDescriptor.layouts[12].stepFunction = .perVertex
        
        return vertexDescriptor
    }
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
    
    static func setDefaultBuffers(encoder: SCEncoder) {
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 0)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 1)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 2)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 3)
        
        encoder.setVertexBytes([f4.zero], length: f4.memorySize, index: 10)
        encoder.setVertexBytes([f2.zero], length: f2.memorySize, index: 11)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: 12)
        
        encoder.setVertexBytes([f4x4.createIdentity()], length: f4x4.memorySize, index: 15)
        
        encoder.setFragmentBytes([Material(ambient: f3.zero, diffuse: f3.zero, specular: f3.zero, shininess: 0)], length: Material.memorySize, index: 1)
        encoder.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        encoder.setFragmentBytes([false], length: Bool.memorySize, index: 7)
        
        encoder.setFragmentBytes([0.0], length: Float.memorySize, index: 16)
        encoder.setFragmentBytes([f4.zero], length: f4.memorySize, index: 17)
    }
}
