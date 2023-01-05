//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

import Foundation
import simd
import Metal

public struct Light {
    public init(position: f3, color: f3, brightness: Float, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float) {
        self.position = position
        self.color = color
        self.brightness = brightness
        self.ambientIntensity = ambientIntensity
        self.diffuseIntensity = diffuseIntensity
        self.specularIntensity = specularIntensity
    }
    public var position: f3
    public var color: f3
    public var brightness: Float
    public var ambientIntensity: Float
    public var diffuseIntensity: Float
    public var specularIntensity: Float
    public static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
