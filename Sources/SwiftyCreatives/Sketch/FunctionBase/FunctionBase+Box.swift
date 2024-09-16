//
//  FunctionBase+Box.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, _ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        Self.setUniforms(encoder, modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, scaleZ), hasTexture: false)
        Self.setVertices(encoder, BoxInfo.vertices)
        Self.setUVs(encoder, BoxInfo.uvs)
        Self.setNormals(encoder, BoxInfo.normals)
        encoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, _ scale: Float) {
        Self.box(encoder, 0, 0, 0, scale, scale, scale)
    }

    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, _ pos: f3, _ scale: f3) {
        Self.box(encoder, pos.x, pos.y, pos.z, scale.x, scale.y, scale.z)
    }
    
    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        Self.box(encoder, 0, 0, 0, scaleX, scaleY, scaleZ)
    }
    
    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, _ scale: f3) {
        Self.box(encoder, 0, 0, 0, scale.x, scale.y, scale.z)
    }
}
