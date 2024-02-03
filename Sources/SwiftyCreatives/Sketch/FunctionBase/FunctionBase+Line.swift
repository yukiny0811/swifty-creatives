//
//  FunctionBase+Line.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func line(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        setVertices([f3(x1, y1, z1), f3(x2, y2, z2)])
        setUVs([f2.zero, f2.zero])
        setNormals([f3.zero, f3.zero])
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
    
    func line(_ pos1: f3, _ pos2: f3) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        setVertices([pos1, pos2])
        setUVs([f2.zero, f2.zero])
        setNormals([f3.zero, f3.zero])
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
}
