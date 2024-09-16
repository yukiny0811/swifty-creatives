//
//  FunctionBase+Line.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func line(_ encoder: MTLRenderCommandEncoder?, _ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        Self.setVertices(encoder, [f3(x1, y1, z1), f3(x2, y2, z2)])
        Self.setUVs(encoder, [f2.zero, f2.zero])
        Self.setNormals(encoder, [f3.zero, f3.zero])
        encoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
    
    @DrawFunction
    static func line(_ encoder: MTLRenderCommandEncoder?, _ pos1: f3, _ pos2: f3) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        Self.setVertices(encoder, [pos1, pos2])
        Self.setUVs(encoder, [f2.zero, f2.zero])
        Self.setNormals(encoder, [f3.zero, f3.zero])
        encoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
}
