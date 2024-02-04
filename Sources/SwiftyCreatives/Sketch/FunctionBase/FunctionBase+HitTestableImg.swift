//
//  FunctionBase+HitTestableImg.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    func img(_ hitTestableImg: HitTestableImg) {
        setUniforms(modelPos: .zero, modelScale: hitTestableImg.scale, hasTexture: true)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setTexture(hitTestableImg.texture)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
        hitTestableImg.cachedCustomMatrix = customMatrix.reduce(f4x4.createIdentity(), *)
    }
}
