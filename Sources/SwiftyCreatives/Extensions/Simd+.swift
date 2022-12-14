//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import simd

public extension simd_float3 {
    static func randomPoint(_ range: ClosedRange<Float>) -> Self {
        return Self(Float.random(in: range), Float.random(in: range), Float.random(in: range))
    }
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

public extension simd_float4 {
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
