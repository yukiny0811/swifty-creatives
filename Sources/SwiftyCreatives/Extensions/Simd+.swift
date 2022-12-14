//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

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
