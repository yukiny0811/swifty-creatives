//
//  FunctionBase+Triangle.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(TriangleInfo.vertices)
        setUVs(TriangleInfo.uvs)
        setNormals(TriangleInfo.normals)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: pos, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(TriangleInfo.vertices)
        setUVs(TriangleInfo.uvs)
        setNormals(TriangleInfo.normals)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scale: Float) {
        setUniforms(modelPos: f3(x, y, z), modelScale: f3(scale, scale, 1), hasTexture: false)
        setVertices(TriangleInfo.vertices)
        setUVs(TriangleInfo.uvs)
        setNormals(TriangleInfo.normals)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ scale: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(scale, scale, 1), hasTexture: false)
        setVertices(TriangleInfo.vertices)
        setUVs(TriangleInfo.uvs)
        setNormals(TriangleInfo.normals)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func triangle(_ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(TriangleInfo.vertices)
        setUVs(TriangleInfo.uvs)
        setNormals(TriangleInfo.normals)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
}

