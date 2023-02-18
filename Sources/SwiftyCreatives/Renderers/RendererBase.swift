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
        
        vertexDescriptor.attributes[VertexAttributeIndex.Position.rawValue].format = .float3
        vertexDescriptor.attributes[VertexAttributeIndex.Position.rawValue].offset = 0
        vertexDescriptor.attributes[VertexAttributeIndex.Position.rawValue].bufferIndex = 0
        
        vertexDescriptor.attributes[VertexAttributeIndex.UV.rawValue].format = .float2
        vertexDescriptor.attributes[VertexAttributeIndex.UV.rawValue].offset = 0
        vertexDescriptor.attributes[VertexAttributeIndex.UV.rawValue].bufferIndex = 11
        
        vertexDescriptor.attributes[VertexAttributeIndex.Normal.rawValue].format = .float3
        vertexDescriptor.attributes[VertexAttributeIndex.Normal.rawValue].offset = 0
        vertexDescriptor.attributes[VertexAttributeIndex.Normal.rawValue].bufferIndex = 12
        
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stride = 16
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stepFunction = .perVertex
        
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stride = 8
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stepFunction = .perVertex
        
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stride = 16
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stepFunction = .perVertex
        
        return vertexDescriptor
    }
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
    
    static func setDefaultBuffers(encoder: SCEncoder) {
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelRot.rawValue)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        
        encoder.setVertexBytes([f4.zero], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes([f2.zero], length: f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        
        encoder.setVertexBytes([f4x4.createIdentity()], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
        
        encoder.setFragmentBytes([Material(ambient: f3.zero, diffuse: f3.zero, specular: f3.zero, shininess: 0)], length: Material.memorySize, index: FragmentBufferIndex.Material.rawValue)
        encoder.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        
        encoder.setFragmentBytes([0.0], length: Float.memorySize, index: FragmentBufferIndex.FogDensity.rawValue)
        encoder.setFragmentBytes([f4.zero], length: f4.memorySize, index: FragmentBufferIndex.FogColor.rawValue)
    }
}
