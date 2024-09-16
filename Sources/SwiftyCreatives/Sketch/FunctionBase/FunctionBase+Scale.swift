//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/02.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func scale(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ value: f3) {
        let scaleMatrix = f4x4.createScale(value.x, value.y, value.z)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * scaleMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func scale(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ value: Float) {
        let scaleMatrix = f4x4.createScale(value, value, value)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * scaleMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func scale(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ x: Float, _ y: Float, _ z: Float) {
        let scaleMatrix = f4x4.createScale(x, y, z)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * scaleMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
}
