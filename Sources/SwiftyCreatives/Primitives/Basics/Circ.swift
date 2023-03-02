//
//  Circ.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import Metal

open class Circ: Primitive<CircleInfo> {
    public override init() { super.init() }
    public override func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(CircleInfo.vertices, length: CircleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(CircleInfo.uvs, length: CircleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(CircleInfo.normals, length: CircleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes(_material, length: Material.memorySize, index: FragmentBufferIndex.Material.rawValue)
        encoder.setFragmentBytes(self.hasTexture, length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentBytes(self.isActiveToLight, length: Bool.memorySize, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
}
