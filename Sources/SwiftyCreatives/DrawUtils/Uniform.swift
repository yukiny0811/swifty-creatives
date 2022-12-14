//
//  Uniform.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

struct Uniform {
    var projectionMatrix: f4x4
    var viewMatrix: f4x4
    static var memorySize: Int {
        return MemoryLayout<Uniform>.stride
    }
} 
