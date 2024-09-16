//
//  FunctionBase+Circle.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func circle(_ encoder: MTLRenderCommandEncoder?, _ x: Float, _ y: Float, _ z: Float, _ radX: Float, _ radY: Float) {
        Self.setUniforms(encoder, modelPos: f3(x, y, z), modelScale: f3(radX, radY, 1), hasTexture: false)
        Self.setVertices(encoder, CircleInfo.vertices)
        Self.setUVs(encoder, CircleInfo.uvs)
        Self.setNormals(encoder, CircleInfo.normals)
        Self.setVertexColors(encoder, CircleInfo.vertices.map { _ in f4.zero })
        encoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    @DrawFunction
    static func circle(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ radX: Float, _ radY: Float) {
        Self.circle(encoder, pos.x, pos.y, pos.z, radX, radY)
    }
    
    @DrawFunction
    static func circle(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ rad: Float) {
        Self.circle(encoder, pos.x, pos.y, pos.z, rad, rad)
    }
    
    @DrawFunction
    static func circle(_ encoder: MTLRenderCommandEncoder?, _ rad: Float) {
        Self.circle(encoder, 0, 0, 0, rad, rad)
    }
    
    @DrawFunction
    static func circle(_ encoder: MTLRenderCommandEncoder?, _ radX: Float, _ radY: Float) {
        Self.circle(encoder, 0, 0, 0, radX, radY)
    }
}
