//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/05.
//

import simd
import SimpleSimdSwift
import Metal
import CoreImage

public extension HasSketchFunctions {

    @DrawFunction
    static func model(_ encoder: MTLRenderCommandEncoder?, _ modelObject: ModelObject) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(encoder!)
    }
    
    @DrawFunction
    static func model(_ encoder: MTLRenderCommandEncoder?, _ modelObject: ModelObject, primitiveType: MTLPrimitiveType) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(encoder!, primitiveType: primitiveType)
    }
    
    @DrawFunction
    static func model(_ encoder: MTLRenderCommandEncoder?, _ modelObject: ModelObject, with image: CGImage) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(encoder!, with: image)
    }
    
    @DrawFunction
    static func model(_ encoder: MTLRenderCommandEncoder?, _ modelObject: ModelObject, with texture: MTLTexture) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(encoder!, with: texture)
    }
}
