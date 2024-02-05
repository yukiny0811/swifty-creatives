//
//  FunctionBase.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import Metal
import SimpleSimdSwift

public protocol FunctionBase: AnyObject {
    var privateEncoder: SCEncoder? { get set }
    var customMatrix: [f4x4] { get set }
}

extension FunctionBase {
    
    internal func setUniforms(modelPos: f3, modelScale: f3, hasTexture: Bool, useVertexColor: Bool = false) {
        setModelPos(modelPos)
        setModelScale(modelScale)
        setHasTexture(hasTexture)
        setUseVertexColor(useVertexColor)
    }
    
    private func setModelPos(_ value: f3) {
        privateEncoder?.setVertexBytes([value], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
    }
    
    private func setModelScale(_ value: f3) {
        privateEncoder?.setVertexBytes([value], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
    }
    
    internal func setVertices(_ value: [f3]) {
        privateEncoder?.setVertexBytes(value, length: value.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
    }
    
    internal func setUVs(_ value: [f2]) {
        privateEncoder?.setVertexBytes(value, length: value.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
    }
    
    internal func setNormals(_ value: [f3]) {
        privateEncoder?.setVertexBytes(value, length: value.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
    }
    
    private func setHasTexture(_ value: Bool) {
        privateEncoder?.setFragmentBytes([value], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
    }
    
    internal func setColor(_ value: f4) {
        privateEncoder?.setVertexBytes([value], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    internal func setFogDensity(_ value: Float) {
        privateEncoder?.setFragmentBytes([value], length: Float.memorySize, index: FragmentBufferIndex.FogDensity.rawValue)
    }
    
    internal func setFogColor(_ value: f4) {
        privateEncoder?.setFragmentBytes([value], length: f4.memorySize, index: FragmentBufferIndex.FogColor.rawValue)
    }
    
    internal func setTexture(_ value: MTLTexture?) {
        privateEncoder?.setFragmentTexture(value, index: FragmentTextureIndex.MainTexture.rawValue)
    }
    
    internal func setCustomMatrix() {
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    internal func setUseVertexColor(_ value: Bool) {
        privateEncoder?.setVertexBytes([value], length: Bool.memorySize, index: VertexBufferIndex.UseVertexColor.rawValue)
    }
    
    internal func setVertexColors(_ value: [f4]) {
        privateEncoder?.setVertexBytes(value, length: value.count * f4.memorySize, index: VertexBufferIndex.VertexColor.rawValue)
    }
}
