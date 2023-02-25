//
//  Primitive.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import simd

open class Primitive<Info: PrimitiveInfo> {
    
    open var hasTexture: [Bool] = [false]
    open var isActiveToLight: [Bool] = [false]
    
    internal var _color: [f4] = [f4.zero]
    internal var _mScale: [f3] = [f3.one]
    internal var _material: [Material] = [Material(ambient: f3(1, 1, 1), diffuse: f3(1, 1, 1), specular: f3.one, shininess: 50)]
    
    public var color: f4 { _color[0] }
    public var scale: f3 { _mScale[0] }
    
    init() {}
    
    @discardableResult
    public func setColor(_ value: f4) -> Self {
        _color[0] = value
        return self
    }
    
    @discardableResult
    public func setScale(_ value: f3) -> Self {
        _mScale[0] = value
        return self
    }
    
    @discardableResult
    public func setMaterial(_ material: Material) -> Self {
        _material[0] = material
        return self
    }
    
    public func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(Info.vertices, length: Info.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(Info.uvs, length: Info.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(Info.normals, length: Info.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes(_material, length: Material.memorySize, index: FragmentBufferIndex.Material.rawValue)
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
