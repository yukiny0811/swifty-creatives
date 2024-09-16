//
//  FunctionBase+Triangle.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func triangle(_ encoder: MTLRenderCommandEncoder?, _ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, TriangleInfo.vertices)
        Self.setUVs(encoder, TriangleInfo.uvs)
        Self.setNormals(encoder, TriangleInfo.normals)
        encoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }

    @DrawFunction
    static func triangle(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: pos, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, TriangleInfo.vertices)
        Self.setUVs(encoder, TriangleInfo.uvs)
        Self.setNormals(encoder, TriangleInfo.normals)
        encoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }

    @DrawFunction
    static func triangle(_ encoder: MTLRenderCommandEncoder?, _ x: Float, _ y: Float, _ z: Float, _ scale: Float) {
        Self.setUniforms(encoder, modelPos: f3(x, y, z), modelScale: f3(scale, scale, 1), hasTexture: false)
        Self.setVertices(encoder, TriangleInfo.vertices)
        Self.setUVs(encoder, TriangleInfo.uvs)
        Self.setNormals(encoder, TriangleInfo.normals)
        encoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }

    @DrawFunction
    static func triangle(_ encoder: MTLRenderCommandEncoder?, _ scale: Float) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: f3(scale, scale, 1), hasTexture: false)
        Self.setVertices(encoder, TriangleInfo.vertices)
        Self.setUVs(encoder, TriangleInfo.uvs)
        Self.setNormals(encoder, TriangleInfo.normals)
        encoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }

    @DrawFunction
    static func triangle(_ encoder: MTLRenderCommandEncoder?, _ scaleX: Float, _ scaleY: Float) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: f3(scaleX, scaleY, 1), hasTexture: false)
        Self.setVertices(encoder, TriangleInfo.vertices)
        Self.setUVs(encoder, TriangleInfo.uvs)
        Self.setNormals(encoder, TriangleInfo.normals)
        encoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
}

