//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/29.
//

import SimpleSimdSwift
import Metal

public extension FunctionBase {
    func mesh(_ vertices: [f3], primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        setVertices(vertices)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
    func mesh(_ buffer: MTLBuffer, count: Int, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        privateEncoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: count)
    }
}
