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

public extension FunctionBase {
    
    func model(_ modelObject: ModelObject) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(privateEncoder!)
    }
    
    func model(_ modelObject: ModelObject, primitiveType: MTLPrimitiveType) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(privateEncoder!, primitiveType: primitiveType)
    }
    
    func model(_ modelObject: ModelObject, with image: CGImage) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(privateEncoder!, with: image)
    }
    
    func model(_ modelObject: ModelObject, with texture: MTLTexture) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        modelObject.draw(privateEncoder!, with: texture)
    }
}
