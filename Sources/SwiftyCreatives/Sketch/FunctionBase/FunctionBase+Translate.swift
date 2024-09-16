//
//  FunctionBase+Translate.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func translate(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ x: Float, _ y: Float, _ z: Float) {
        let translateMatrix = f4x4.createTransform(x, y, z)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * translateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }

    @DrawFunction
    static func translate(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ value: f3) {
        let translateMatrix = f4x4.createTransform(value.x, value.y, value.z)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * translateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
}
