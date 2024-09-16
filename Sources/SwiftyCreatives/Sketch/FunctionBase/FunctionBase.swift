//
//  FunctionBase.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import Metal
import SimpleSimdSwift

open class HasSketchFunctions {
    public var encoder: MTLRenderCommandEncoder?
    public var customMatrix: [f4x4] = [f4x4.createIdentity()]
    public init() {}
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
    @DrawFunction internal static func setHasTexture(_ encoder: MTLRenderCommandEncoder?, _ value: Bool) {
        encoder?.setFragmentBytes([value], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
    }
    @DrawFunction internal static func setUseVertexColor(_ encoder: MTLRenderCommandEncoder?, _ value: Bool) {
        encoder?.setVertexBytes([value], length: Bool.memorySize, index: VertexBufferIndex.UseVertexColor.rawValue)
    }
    @DrawFunction internal static func setColor(_ encoder: MTLRenderCommandEncoder?, _ value: f4) {
        encoder?.setVertexBytes([value], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    @DrawFunction internal static func setTexture(_ encoder: MTLRenderCommandEncoder?, _ value: MTLTexture?) {
        encoder?.setFragmentTexture(value, index: FragmentTextureIndex.MainTexture.rawValue)
    }
    @DrawFunction internal static func setCustomMatrix(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4]) {
        encoder?.setVertexBytes([customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    @DrawFunction internal static func setVertexColors(_ encoder: MTLRenderCommandEncoder?, _ value: [f4]) {
        encoder?.setVertexBytes(value, length: value.count * f4.memorySize, index: VertexBufferIndex.VertexColor.rawValue)
    }
    @DrawFunction internal static func setFogDensity(_ encoder: MTLRenderCommandEncoder?, _ value: Float) {
        encoder?.setFragmentBytes([value], length: Float.memorySize, index: FragmentBufferIndex.FogDensity.rawValue)
    }
    @DrawFunction internal static func setFogColor(_ encoder: MTLRenderCommandEncoder?, _ value: f4) {
        encoder?.setFragmentBytes([value], length: f4.memorySize, index: FragmentBufferIndex.FogColor.rawValue)
    }
    @DrawFunction internal static func setUniforms(_ encoder: MTLRenderCommandEncoder?, modelPos: f3, modelScale: f3, hasTexture: Bool, useVertexColor: Bool = false) {
        Self.setModelPos(encoder, modelPos)
        Self.setModelScale(encoder, modelScale)
        Self.setHasTexture(encoder, hasTexture)
        Self.setUseVertexColor(encoder, useVertexColor)
    }
}
