//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import simd

struct Vertex {
    var position: simd_float3
    var color: simd_float4
    var modelMatrix1: simd_float4
    var modelMatrix2: simd_float4
    var modelMatrix3: simd_float4
    var modelMatrix4: simd_float4
    static var memorySize: Int {
        return MemoryLayout<Vertex>.stride
    }
}
