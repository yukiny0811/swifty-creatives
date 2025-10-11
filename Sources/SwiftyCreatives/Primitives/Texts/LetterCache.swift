//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import Foundation
import Metal
import SimpleSimdSwift

public struct LetterCache {
    public var buffer: MTLBuffer
    public var verticeCount: Int
    public var offset: simd_double2
    public var size: simd_double2
}

public struct LetterCacheRaw {
    public var vertices: [simd_double3]
    public var offset: simd_double2
    public var size: simd_double2
}
