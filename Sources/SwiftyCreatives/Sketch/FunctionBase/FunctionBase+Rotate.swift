//
//  FunctionBase+Rotate.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func rotate(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ rad: Float, axis: f3) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: axis)
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * rotateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func rotate(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ rad: Float, _ axisX: Float, _ axisY: Float, _ axisZ: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(axisX, axisY, axisZ))
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * rotateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func rotateX(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(1, 0, 0))
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * rotateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func rotateY(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 1, 0))
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * rotateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
    
    @DrawFunction
    static func rotateZ(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 0, 1))
        customMatrix[customMatrix.count - 1] = customMatrix[customMatrix.count - 1] * rotateMatrix
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }
}
