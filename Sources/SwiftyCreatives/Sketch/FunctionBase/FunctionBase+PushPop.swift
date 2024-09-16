//
//  FunctionBase+PushPop.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func pushMatrix(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4]) {
        customMatrix.append(f4x4.createIdentity())
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }

    @DrawFunction
    static func popMatrix(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4]) {
        let _ = customMatrix.popLast()
        Self.setCustomMatrix(encoder, customMatrix: &customMatrix)
    }

    @DrawFunction
    static func push(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ process: () -> Void) {
        Self.pushMatrix(encoder, customMatrix: &customMatrix)
        process()
        Self.popMatrix(encoder, customMatrix: &customMatrix)
    }
}
