
//  FunctionBase+Img.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import Metal
import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    func img(_ encoder: MTLRenderCommandEncoder?, texture: MTLTexture, with option: ImageAdjustOption) {
        let adjustedScale = ImageAdjuster.adjustedScale(width: Float(texture.width), height: Float(texture.height), with: option)
        Self.setUniforms(encoder, modelPos: .zero, modelScale: adjustedScale, hasTexture: true)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        Self.setTexture(encoder, texture)
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    @DrawFunction
    func img(_ encoder: MTLRenderCommandEncoder?, _ imgObj: Img) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: imgObj.scale, hasTexture: true)
        Self.setVertices(encoder, RectShapeInfo.vertices)
        Self.setUVs(encoder, RectShapeInfo.uvs)
        Self.setNormals(encoder, RectShapeInfo.normals)
        Self.setVertexColors(encoder, RectShapeInfo.vertices.map { _ in f4.zero })
        Self.setTexture(encoder, imgObj.texture)
        encoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
