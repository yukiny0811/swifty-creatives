//
//  MathUtil.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/01.
//

import simd

precedencegroup ExponentPrecedence {
    lowerThan: BitwiseShiftPrecedence
    higherThan: MultiplicationPrecedence
    associativity: left
}
infix operator ^ : ExponentPrecedence
func ^(left: Float, right: Float) -> Float {
    return pow(left, right)
}
func ^(left: Double, right: Double) -> Double {
    return pow(left, right)
}
func ^(left: Float, right: Double) -> Float {
    return pow(left, Float(right))
}
func ^(left: Double, right: Float) -> Float {
    return pow(Float(left), right)
}
func ^(left: Int, right: Float) -> Float {
    return pow(Float(left), right)
}
func ^(left: Int, right: Double) -> Double {
    return pow(Double(left), right)
}
func ^(left: Int, right: Int) -> Float {
    return pow(Float(left), Float(right))
}
func ^(left: Float, right: Int) -> Float {
    return pow(left, Float(right))
}
func ^(left: Double, right: Int) -> Double {
    return pow(left, Double(right))
}


infix operator .+ : AdditionPrecedence
func .+(left: Float, right: simd_float2x2) -> simd_float2x2 {
    return simd_float2x2(
        right.columns.0 + left,
        right.columns.1 + left
    )
}
func .+(left: Float, right: simd_float3x3) -> simd_float3x3 {
    return simd_float3x3(
        right.columns.0 + left,
        right.columns.1 + left,
        right.columns.2 + left
    )
}
func .+(left: Float, right: simd_float4x4) -> simd_float4x4 {
    return simd_float4x4(
        right.columns.0 + left,
        right.columns.1 + left,
        right.columns.2 + left,
        right.columns.3 + left
    )
}
func .+(left: simd_float2x2, right: Float) -> simd_float2x2 {
    return simd_float2x2(
        left.columns.0 + right,
        left.columns.1 + right
    )
}
func .+(left: simd_float3x3, right: Float) -> simd_float3x3 {
    return simd_float3x3(
        left.columns.0 + right,
        left.columns.1 + right,
        left.columns.2 + right
    )
}
func .+(left: simd_float4x4, right: Float) -> simd_float4x4 {
    return simd_float4x4(
        left.columns.0 + right,
        left.columns.1 + right,
        left.columns.2 + right,
        left.columns.3 + right
    )
}

infix operator .- : AdditionPrecedence
func .-(left: Float, right: simd_float2x2) -> simd_float2x2 {
    return simd_float2x2(
        left - right.columns.0,
        left - right.columns.1
    )
}
func .-(left: Float, right: simd_float3x3) -> simd_float3x3 {
    return simd_float3x3(
        left - right.columns.0,
        left - right.columns.1,
        left - right.columns.2
    )
}
func .-(left: Float, right: simd_float4x4) -> simd_float4x4 {
    return simd_float4x4(
        left - right.columns.0,
        left - right.columns.1,
        left - right.columns.2,
        left - right.columns.3
    )
}
func .-(left: simd_float2x2, right: Float) -> simd_float2x2 {
    return simd_float2x2(
        left.columns.0 - right,
        left.columns.1 - right
    )
}
func .-(left: simd_float3x3, right: Float) -> simd_float3x3 {
    return simd_float3x3(
        left.columns.0 - right,
        left.columns.1 - right,
        left.columns.2 - right
    )
}
func .-(left: simd_float4x4, right: Float) -> simd_float4x4 {
    return simd_float4x4(
        left.columns.0 - right,
        left.columns.1 - right,
        left.columns.2 - right,
        left.columns.3 - right
    )
}
