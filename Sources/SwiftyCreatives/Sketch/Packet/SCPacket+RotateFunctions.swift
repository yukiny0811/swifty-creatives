//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import simd

public extension SCPacket {
    
    func rotate(_ rad: Float, axis: f3) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: axis)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotate(_ rad: Float, _ axisX: Float, _ axisY: Float, _ axisZ: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(axisX, axisY, axisZ))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
}
