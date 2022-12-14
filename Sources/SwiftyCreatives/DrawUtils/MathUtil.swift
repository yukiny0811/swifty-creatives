//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import Foundation
import simd

final class MathUtil {
    static func makePrespective(rad: Float, aspect: Float, near: Float, far: Float) -> simd_float4x4 {
        let ys: Float = 1.0 / tanf(rad * 0.5)
        let xs: Float = ys / aspect
        let zs: Float = far / (far - near)
        return simd_float4x4(
            simd_float4(xs, 0, 0, 0),
            simd_float4(0, ys, 0, 0),
            simd_float4(0, 0, zs, 1),
            simd_float4(0, 0, -near * zs, 0)
        )
    }
    static func makeTranslationMatrix(x: Float, y: Float, z: Float) -> simd_float4x4 {
        return simd_float4x4(
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(x, y, z, 1)
        )
    }
}
