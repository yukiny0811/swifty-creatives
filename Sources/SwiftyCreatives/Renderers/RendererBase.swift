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
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = 16
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = 32
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = 48
        vertexDescriptor.attributes[3].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = 64
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        
        return vertexDescriptor
    }
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
}
