//
//  FunctionBase+HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func box(_ encoder: MTLRenderCommandEncoder?, customMatrix: inout [f4x4], _ hitTestableBox: HitTestableBox) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)

        Self.pushMatrix(encoder, customMatrix: &customMatrix)
        do {
            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, hitTestableBox.scale.z)
                hitTestableBox.front.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)

            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, -hitTestableBox.scale.z)
                hitTestableBox.back.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)

            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.rotateY(encoder, customMatrix: &customMatrix, Float.pi/2)
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, hitTestableBox.scale.x)
                hitTestableBox.l.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)

            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.rotateY(encoder, customMatrix: &customMatrix, Float.pi/2)
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, -hitTestableBox.scale.x)
                hitTestableBox.r.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)

            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.rotateX(encoder, customMatrix: &customMatrix, Float.pi/2)
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, hitTestableBox.scale.y)
                hitTestableBox.top.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)

            Self.pushMatrix(encoder, customMatrix: &customMatrix)
            do {
                Self.rotateX(encoder, customMatrix: &customMatrix, Float.pi/2)
                Self.translate(encoder, customMatrix: &customMatrix, 0, 0, -hitTestableBox.scale.y)
                hitTestableBox.bottom.drawWithCache(encoder: encoder!, customMatrix: customMatrix.reduce(f4x4.createIdentity(), *))
            }
            Self.popMatrix(encoder, customMatrix: &customMatrix)
        }
        Self.popMatrix(encoder, customMatrix: &customMatrix)
    }
}
