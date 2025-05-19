//
//  RendererBase+StaticFunctions.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import Metal

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
        vertexDescriptor.attributes[VertexAttributeIndex.Color.rawValue].format = .float4
        vertexDescriptor.attributes[VertexAttributeIndex.Color.rawValue].offset = 0
        vertexDescriptor.attributes[VertexAttributeIndex.Color.rawValue].bufferIndex = 19
        
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stride = 16
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.Position.rawValue].stepFunction = .perVertex
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stride = 8
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.UV.rawValue].stepFunction = .perVertex
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stride = 16
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.Normal.rawValue].stepFunction = .perVertex
        vertexDescriptor.layouts[VertexBufferIndex.VertexColor.rawValue].stride = 16
        vertexDescriptor.layouts[VertexBufferIndex.VertexColor.rawValue].stepRate = 1
        vertexDescriptor.layouts[VertexBufferIndex.VertexColor.rawValue].stepFunction = .perVertex
        return vertexDescriptor
    }
    
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
    
    static func setDefaultBuffers(encoder: SCEncoder) {
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.ModelPos.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.ModelRot.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f4x4, offset: 0, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f4x4, offset: 0, index: VertexBufferIndex.ViewMatrix.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f4, offset: 0, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f2, offset: 0, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f3, offset: 0, index: VertexBufferIndex.Normal.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f4x4, offset: 0, index: VertexBufferIndex.CustomMatrix.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_false, offset: 0, index: VertexBufferIndex.UseVertexColor.rawValue)
        encoder.setVertexBuffer(DefaultBuffers.default_f4, offset: 0, index: VertexBufferIndex.VertexColor.rawValue)
        encoder.setFragmentBytes([Float(1)], length: Float.memorySize, index: FragmentBufferIndex.LightCount.rawValue)
        encoder.setFragmentBuffer(DefaultBuffers.default_false, offset: 0, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentBuffer(DefaultBuffers.default_false, offset: 0, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        encoder.setFragmentBytes([Float(0)], length: Float.memorySize, index: FragmentBufferIndex.FogDensity.rawValue)
        encoder.setFragmentBuffer(DefaultBuffers.default_f4, offset: 0, index: FragmentBufferIndex.FogColor.rawValue)
    }
}
