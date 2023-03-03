//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import Metal

public extension Sketch {
    func img(texture: MTLTexture, with option: ImageAdjustOption) {
        let adjustedScale = ImageAdjuster.adjustedScale(width: Float(texture.width), height: Float(texture.height), with: option)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([adjustedScale], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.setFragmentTexture(texture, index: FragmentTextureIndex.MainTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
