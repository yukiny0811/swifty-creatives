//
//  DefaultBuffers.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/26.
//

import Metal

enum DefaultBuffers {
    static let default_false = ShaderCore.device.makeBuffer(bytes: [false], length: Bool.memorySize)
    static let default_true = ShaderCore.device.makeBuffer(bytes: [true], length: Bool.memorySize)
    static let default_f2 = ShaderCore.device.makeBuffer(bytes: [f2.zero], length: f2.memorySize)
    static let default_f3 = ShaderCore.device.makeBuffer(bytes: [f3.zero], length: f3.memorySize)
    static let default_f4 = ShaderCore.device.makeBuffer(bytes: [f4.zero], length: f4.memorySize)
    static let default_f4x4 = ShaderCore.device.makeBuffer(bytes: [f4x4.createIdentity()], length: f4x4.memorySize)
}
