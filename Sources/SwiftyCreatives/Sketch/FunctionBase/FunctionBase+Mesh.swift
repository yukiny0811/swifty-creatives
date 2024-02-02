//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/29.
//

import SimpleSimdSwift
import Metal

public extension FunctionBase {
    func mesh(_ vertices: [f3], primitiveType: MTLPrimitiveType = .triangle) {
        privateEncoder?.setVertexBytes(vertices, length: vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
    func mesh(_ buffer: MTLBuffer, count: Int, primitiveType: MTLPrimitiveType = .triangle) {
        privateEncoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: count)
    }
    func meshWithLight(_ vertices: [f3], primitiveType: MTLPrimitiveType = .triangle) {
        privateEncoder?.setVertexBytes(vertices, length: vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
}
