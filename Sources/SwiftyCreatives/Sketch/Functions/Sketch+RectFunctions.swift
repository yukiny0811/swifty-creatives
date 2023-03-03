//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import simd

public extension Sketch {
    
    func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([pos], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ pos: f3, _ scale: Float) {
        privateEncoder?.setVertexBytes([pos], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scale, scale, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scale: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scale, scale, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scale: f3) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([scale], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
