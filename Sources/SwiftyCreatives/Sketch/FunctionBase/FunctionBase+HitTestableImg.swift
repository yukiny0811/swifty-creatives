//
//  FunctionBase+HitTestableImg.swift
//
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func img(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ hitTestableImg: HitTestableImg) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: hitTestableImg.scale, hasTexture: true)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setTexture(encoder, hitTestableImg.texture)
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
        hitTestableImg.cachedCustomMatrix = customMatrix.reduce(f4x4.createIdentity(), *)
    }
}
