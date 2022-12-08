//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import simd

struct SCPoint2 {
    var x: Float
    var y: Float
    var simd: simd_float2 {
        return simd_float2(x, y)
    }
}

public struct SCPoint3: AdditiveArithmetic {
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public static func + (lhs: SCPoint3, rhs: SCPoint3) -> SCPoint3 {
        return SCPoint3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: SCPoint3, rhs: SCPoint3) -> SCPoint3 {
        return SCPoint3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: SCPoint3, scale: Float) -> SCPoint3 {
        return SCPoint3(x: lhs.x * scale, y: lhs.y * scale, z: lhs.z * scale)
    }
    
    public static var zero: SCPoint3 = SCPoint3(x: 0, y: 0, z: 0)
    
    public var x: Float
    public var y: Float
    public var z: Float
    public var simd: simd_float3 {
        return simd_float3(x, y, z)
    }
    public static var randomPoint: SCPoint3 {
        return SCPoint3(x: Float.random(in: -1...1), y: Float.random(in: -1...1), z: Float.random(in: -1...1))
    }
    public static var screenRandomPoint: SCPoint3 {
        return SCPoint3(x: Float.random(in: -1000...1000), y: Float.random(in: -1000...1000), z: Float.random(in: -1000...1000))
    }
    public func convertedFromScreen(scale: Float) -> SCPoint3 {
        return self * (1 / scale)
    }
    public func shrink(_ scale: Float) -> SCPoint3 {
        return self * scale
    }
    
}

struct SCPoint4 {
    var x: Float
    var y: Float
    var z: Float
    var w: Float
    var simd: simd_float4 {
        return simd_float4(x, y, z, w)
    }
}
