//
//  FunctionBase+Text.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

public extension FunctionBase {
    func text(_ textObj: TextObject) {
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(textObj._mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.setFragmentTexture(textObj.texture, index: FragmentTextureIndex.MainTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
