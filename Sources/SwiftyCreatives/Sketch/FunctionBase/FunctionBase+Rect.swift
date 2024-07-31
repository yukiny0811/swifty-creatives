//
//  FunctionBase+Rect.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: pos, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ pos: f3, _ scale: Float) {
        setUniforms(modelPos: pos, modelScale: f3(scale, scale, 1), hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scale: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(scale, scale, 1), hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scale: f3) {
        setUniforms(modelPos: .zero, modelScale: scale, hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func rect(_ scaleX: Float, _ scaleY: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setVertexColors(RectShapeInfo.vertices.map { _ in f4.zero })
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
