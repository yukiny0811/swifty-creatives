//
//  DetailedRendererBase.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import MetalKit

protocol DetailedRendererBase: RendererBase {}

extension DetailedRendererBase {
    static func createVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].offset = 0
        vertexDescriptor.attributes[2].bufferIndex = 2
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = 0
        vertexDescriptor.attributes[3].bufferIndex = 3
        
        vertexDescriptor.attributes[4].format = .float3
        vertexDescriptor.attributes[4].offset = 0
        vertexDescriptor.attributes[4].bufferIndex = 4
        
        vertexDescriptor.layouts[0].stride = f3.memorySize
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        
        vertexDescriptor.layouts[1].stride = f4.memorySize
        vertexDescriptor.layouts[1].stepRate = 1
        vertexDescriptor.layouts[1].stepFunction = .perVertex
        
        vertexDescriptor.layouts[2].stride = f3.memorySize
        vertexDescriptor.layouts[2].stepRate = 1
        vertexDescriptor.layouts[2].stepFunction = .perVertex
        
        vertexDescriptor.layouts[3].stride = f3.memorySize
        vertexDescriptor.layouts[3].stepRate = 1
        vertexDescriptor.layouts[3].stepFunction = .perVertex
        
        vertexDescriptor.layouts[4].stride = f3.memorySize
        vertexDescriptor.layouts[4].stepRate = 1
        vertexDescriptor.layouts[4].stepFunction = .perVertex
        
        return vertexDescriptor
    }
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
}
