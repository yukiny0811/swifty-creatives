//
//  Float+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

public extension Float {
    static func degreesToRadians(_ deg: Float) -> Self {
        return Self(deg / 360 * Float.pi * 2)
    }
}
