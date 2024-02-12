//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

import Foundation
import SwiftyCreativesCore
import MetalKit

open class RayMarchSketch {
    
    public var objects: [RayMarchObject] = []
    
    public var customMatrix: [f4x4] = [.createIdentity()]
    
    public var marchCount = 256
    
    public var startDate = Date()
    public var lastFrameDate = Date()
    public var elapsedTime: Float = 0
    public var deltaTime: Float = 0
    public var frameRate: Float = 0
    
    public init() {}
    
    func clearObjects() {
        customMatrix = [.createIdentity()]
        objects.removeAll()
    }
    
    open func updateUniform(uniform: inout RayMarchUniform) {}
    
    open func draw() {}
    
    public func translate(_ x: Float, _ y: Float, _ z: Float) {
        customMatrix[customMatrix.endIndex-1] *= .createTransform(x, y, z)
    }
    
    public func sphere(radius: Float) {
        let object = RayMarchObject(
            objectType: 1,
            inverseTransform: simd_inverse(customMatrix.reduce(f4x4.createIdentity(), *)),
            parameter1: f4(radius, 0, 0, 0),
            parameter2: .zero,
            parameter3: .zero
        )
        objects.append(object)
    }
    
    public func box(_ sizeX: Float, _ sizeY: Float, _ sizeZ: Float) {
        let object = RayMarchObject(
            objectType: 2,
            inverseTransform: simd_inverse(customMatrix.reduce(f4x4.createIdentity(), *)),
            parameter1: f4(sizeX, sizeY, sizeZ, 0),
            parameter2: .zero,
            parameter3: .zero
        )
        objects.append(object)
    }
}


