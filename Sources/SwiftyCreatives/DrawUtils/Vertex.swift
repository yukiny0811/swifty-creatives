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
    var modelPos: simd_float3
    var modelRot: simd_float3
    var modelScale: simd_float3
    static var memorySize: Int {
        return MemoryLayout<Vertex>.stride
    }
}
