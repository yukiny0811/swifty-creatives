//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import simd

open class Primitive<Info: PrimitiveInfo>: PrimitiveBase {
    
    open var hasTexture: [Bool] = [false]
    open var isActiveToLight: [Bool] = [false]
    
    internal var _color: [f4] = [f4.zero]
    internal var _mPos: [f3] = [f3.zero]
    internal var _mRot: [f3] = [f3.zero]
    internal var _mScale: [f3] = [f3.one]
    internal var _material: [Material] = [Material(ambient: f3(1, 1, 1), diffuse: f3(1, 1, 1), specular: f3.one, shininess: 50)]
    
    public var color: f4 { _color[0] }
    public var pos: f3 { _mPos[0] }
    public var rot: f3 { _mRot[0] }
    public var scale: f3 { _mScale[0] }
    
    required public init() {}
    
    @discardableResult
    public func setColor(_ value: f4) -> Self {
        _color[0] = value
        return self
    }
    
    @discardableResult
    public func setPos(_ value: f3) -> Self {
        _mPos[0] = value
        return self
    }
    
    @discardableResult
    public func setRot(_ value: f3) -> Self {
        _mRot[0] = value
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
        encoder.setFragmentBytes(_material, length: Material.memorySize, index: 1)
        encoder.setVertexBytes(Info.vertices, length: Info.vertices.count * f3.memorySize, index: 0)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 1)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 3)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 10)
        encoder.setVertexBytes(Info.uvs, length: Info.uvs.count * f2.memorySize, index: 11)
        encoder.setVertexBytes(Info.normals, length: Info.normals.count * f3.memorySize, index: 12)
        encoder.setFragmentBytes(self.hasTexture, length: MemoryLayout<Bool>.stride, index: 6)
        encoder.setFragmentBytes(self.isActiveToLight, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.drawPrimitives(type: Info.primitiveType, vertexStart: 0, vertexCount: Info.vertices.count)
    }
    
    // util functions
    @discardableResult
    public func multiplyScale(_ value: Float) -> Self {
        _mScale[0] *= value
        return self
    }
    
    public func mockModel() -> f4x4 {
        let rotX = f4x4.createRotation(angle: self.rot.x, axis: f3(1, 0, 0))
        let rotY = f4x4.createRotation(angle: self.rot.y, axis: f3(0, 1, 0))
        let rotZ = f4x4.createRotation(angle: self.rot.z, axis: f3(0, 0, 1))
        let trans = f4x4.createTransform(self.pos.x, self.pos.y, self.pos.z)
        let model = trans * rotZ * rotY * rotX
        return model
    }
}
