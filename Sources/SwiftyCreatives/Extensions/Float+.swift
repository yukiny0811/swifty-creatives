//
//  Float+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

extension Float {
    public static func degreesToRadians(_ deg: Float) -> Self {
        return Self(deg / 360 * Float.pi * 2)
    }
    public func degreesToRadians() -> Self {
        return Self(self / 360 * Float.pi * 2)
    }
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
