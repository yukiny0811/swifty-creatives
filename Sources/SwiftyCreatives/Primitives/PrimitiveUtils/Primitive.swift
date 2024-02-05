//
//  Primitive.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import simd

open class Primitive<Info: PrimitiveInfo>: ScaleSettable {
    
    open var hasTexture: [Bool] = [false]
    open var isActiveToLight: [Bool] = [false]
    
    internal var _mScale: [f3] = [f3.one]
    
    public var scale: f3 { _mScale[0] }
    
    init() {}
    
    @discardableResult
    public func setScale(_ value: f3) -> Self {
        _mScale[0] = value
        return self
    }
    
    public func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(Info.vertices, length: Info.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(Info.uvs, length: Info.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(Info.normals, length: Info.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setVertexBytes([f4](repeating: .zero, count: Info.vertices.count), length: Info.vertices.count * f4.memorySize, index: VertexBufferIndex.VertexColor.rawValue)
        encoder.setFragmentBytes(self.hasTexture, length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentBytes(self.isActiveToLight, length: Bool.memorySize, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        encoder.drawPrimitives(type: Info.primitiveType, vertexStart: 0, vertexCount: Info.vertices.count)
    }
    
    // util functions
    @discardableResult
    public func multiplyScale(_ value: Float) -> Self {
        _mScale[0] *= value
        return self
    }
}
