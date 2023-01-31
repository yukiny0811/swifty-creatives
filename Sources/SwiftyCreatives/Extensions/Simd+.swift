//
//  Simd+.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import simd

public extension f2 {
    static func randomPoint(_ range: ClosedRange<Float>) -> Self {
        return Self(Float.random(in: range), Float.random(in: range))
    }
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}


public extension f3 {
    static func randomPoint(_ range: ClosedRange<Float>) -> Self {
        return Self(Float.random(in: range), Float.random(in: range), Float.random(in: range))
    }
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

public extension f4 {
    static func randomPoint(_ range: ClosedRange<Float>) -> Self {
        return Self(Float.random(in: range), Float.random(in: range), Float.random(in: range), Float.random(in: range))
    }
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

public extension f4x4 {
    static func createTransform(_ x: Float, _ y: Float, _ z: Float) -> Self {
        return simd_transpose(Self.init(
            f4(1, 0, 0, x),
            f4(0, 1, 0, y),
            f4(0, 0, 1, z),
            f4(0, 0, 0, 1)
        ))
    }
    static func createRotation(angle: Float, axis: f3) -> Self {
        return Self.init(
            simd_quatf(angle: angle, axis: axis)
        )
    }
    static func createPerspective(fov: Float, aspect: Float, near: Float, far: Float) -> Self {
        let f: Float = 1.0 / (tan(fov / 2.0))
        return simd_transpose(Self.init(
            f4(f / aspect, 0, 0, 0),
            f4(0, f, 0, 0),
            f4(0, 0, (near+far)/(near-far), (2 * near * far) / (near - far)),
            f4(0, 0, -1, 0)
        ))
    }
    static func createOrthographic(_ l: Float, _ r: Float, _ b: Float, _ t: Float, _ n: Float, _ f: Float) -> Self {
        return simd_transpose(Self.init(
            f4(2/(r-l), 0, 0, -1 * (r+l) / (r-l)),
            f4(0, 2 / (t-b), 0, -1 * (t+b) / (t-b)),
            f4(0, 0, -2 / (f-n), -1 * (f+n)/(f-n)),
            f4(0, 0, 0, 1)
        ))
    }
    static func createIdentity() -> Self {
        return Self.init(
            f4(1, 0, 0, 0),
            f4(0, 1, 0, 0),
            f4(0, 0, 1, 0),
            f4(0, 0, 0, 1)
        )
    }
}

import GLKit
public extension f4x4 {
    func toGLKMatrix4() -> GLKMatrix4 {
//        return GLKMatrix4(m: (
//            self.columns.0.x, self.columns.1.x, self.columns.2.x, self.columns.3.x,
//            self.columns.0.y, self.columns.1.y, self.columns.2.y, self.columns.3.y,
//            self.columns.0.z, self.columns.1.z, self.columns.2.z, self.columns.3.z,
//            self.columns.0.w, self.columns.1.w, self.columns.2.w, self.columns.3.w
//        ))
        return GLKMatrix4(m: (
            self.columns.0.x, self.columns.0.y, self.columns.0.z, self.columns.0.w,
            self.columns.1.x, self.columns.1.y, self.columns.1.z, self.columns.1.w,
            self.columns.2.x, self.columns.2.y, self.columns.2.z, self.columns.2.w,
            self.columns.3.x, self.columns.3.y, self.columns.3.z, self.columns.3.w
        ))
    }
}
