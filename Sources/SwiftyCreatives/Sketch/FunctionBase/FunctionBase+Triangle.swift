//
//  FunctionBase+Triangle.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd

public extension FunctionBase {
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([pos], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scale: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scale, scale, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ scale: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scale, scale, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
}

