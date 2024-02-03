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
    
    internal func setUniforms(modelPos: f3, modelScale: f3, hasTexture: Bool) {
        setModelPos(modelPos)
        setModelScale(modelScale)
        setHasTexture(hasTexture)
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
    
}
