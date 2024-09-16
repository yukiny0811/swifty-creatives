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

public protocol HasSketchFunctions: AnyObject {
    var encoder: MTLRenderCommandEncoder? { get set }
    var customMatrix: [f4x4] { get set }
}

extension HasSketchFunctions {
    @DrawFunction internal static func setModelPos(_ encoder: MTLRenderCommandEncoder?, _ value: f3) {
        encoder?.setVertexBytes([value], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
    }
    @DrawFunction internal static func setModelScale(_ encoder: MTLRenderCommandEncoder?, _ value: f3) {
        encoder?.setVertexBytes([value], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
    }
    @DrawFunction internal static func setVertices(_ encoder: MTLRenderCommandEncoder?, _ value: [f3]) {
        encoder?.setVertexBytes(value, length: value.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
    }
    @DrawFunction internal static func setUVs(_ encoder: MTLRenderCommandEncoder?, _ value: [f2]) {
        encoder?.setVertexBytes(value, length: value.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
    }
    @DrawFunction internal static func setNormals(_ encoder: MTLRenderCommandEncoder?, _ value: [f3]) {
        encoder?.setVertexBytes(value, length: value.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
    }
}

extension FunctionBase {
    
    internal func setUniforms(modelPos: f3, modelScale: f3, hasTexture: Bool, useVertexColor: Bool = false) {
        setModelPos(modelPos)
        setModelScale(modelScale)
        setHasTexture(hasTexture)
        setUseVertexColor(useVertexColor)
    }
    
    internal func setModelPos(_ value: f3) {
        SketchFunctions.setModelPos(privateEncoder, value)
    }
    
    internal func setModelScale(_ value: f3) {
        SketchFunctions.setModelScale(privateEncoder, value)
    }
    
    internal func setVertices(_ value: [f3]) {
        SketchFunctions.setVertices(privateEncoder, value)
    }
    
    internal func setUVs(_ value: [f2]) {
        SketchFunctions.setUVs(privateEncoder, value)
    }
    
    internal func setNormals(_ value: [f3]) {
        SketchFunctions.setNormals(privateEncoder, value)
    }
    
    internal func setHasTexture(_ value: Bool) {
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
