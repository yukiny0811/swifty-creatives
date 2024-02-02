//
//  FunctionBase+Rotate.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
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
    
    func rotateX(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(1, 0, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotateY(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 1, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotateZ(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 0, 1))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
}
