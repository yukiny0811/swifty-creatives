//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/02.
//

import simd

public extension FunctionBase {
    
    func scale(_ value: f3) {
        let scaleMatrix = f4x4.createScale(value.x, value.y, value.z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * scaleMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func scale(_ value: Float) {
        let scaleMatrix = f4x4.createScale(value, value, value)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * scaleMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func scale(_ x: Float, _ y: Float, _ z: Float) {
        let scaleMatrix = f4x4.createScale(x, y, z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * scaleMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
}
