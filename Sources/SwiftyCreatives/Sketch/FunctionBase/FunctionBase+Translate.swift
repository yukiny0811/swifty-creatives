//
//  FunctionBase+Translate.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func translate(_ x: Float, _ y: Float, _ z: Float) {
        let translateMatrix = f4x4.createTransform(x, y, z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * translateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func translate(_ value: f3) {
        let translateMatrix = f4x4.createTransform(value.x, value.y, value.z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * translateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
}
