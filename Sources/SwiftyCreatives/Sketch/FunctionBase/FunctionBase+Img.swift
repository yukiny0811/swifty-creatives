//
//  FunctionBase+Img.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import Metal
import simd
import SimpleSimdSwift

public extension FunctionBase {
    func img(texture: MTLTexture, with option: ImageAdjustOption) {
        let adjustedScale = ImageAdjuster.adjustedScale(width: Float(texture.width), height: Float(texture.height), with: option)
        setUniforms(modelPos: .zero, modelScale: adjustedScale, hasTexture: true)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setTexture(texture)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func img(imgObj: Img) {
        setUniforms(modelPos: .zero, modelScale: imgObj.scale, hasTexture: true)
        setVertices(RectShapeInfo.vertices)
        setUVs(RectShapeInfo.uvs)
        setNormals(RectShapeInfo.normals)
        setTexture(imgObj.texture)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
