//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import MetalKit

open class HitTestableImg: RectanglePlanePrimitive<RectShapeInfo>, ImageLoadable {
    public override init() { super.init() }
    public var texture: MTLTexture?
    
    override public func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentTexture(self.texture, index: FragmentTextureIndex.MainTexture.rawValue)
        encoder.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
