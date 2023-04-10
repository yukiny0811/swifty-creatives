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
    static let default_material = ShaderCore.device.makeBuffer(bytes: [Material(ambient: f3.zero, diffuse: f3.zero, specular: f3.zero, shininess: 0)], length: Material.memorySize)
    static let default_light = ShaderCore.device.makeBuffer(bytes: [Light(position: f3.zero, color: f3.zero, brightness: 0, ambientIntensity: 0, diffuseIntensity: 0, specularIntensity: 0)], length: Light.memorySize)
}
