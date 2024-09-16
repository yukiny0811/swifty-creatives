//
//  FunctionBase+Rect.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: pos, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ scale: Float) {
        Self.setUniforms(encoder, modelPos: pos, modelScale: f3(scale, scale, 1), hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ scale: Float) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: f3(scale, scale, 1), hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ scale: f3) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: scale, hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    static func rect(_ encoder: MTLRenderCommandEncoder?, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
