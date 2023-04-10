//
//  FunctionBase+PushPop.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd

public extension FunctionBase {
    func pushMatrix() {
        self.customMatrix.append(f4x4.createIdentity())
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    func popMatrix() {
        let _ = self.customMatrix.popLast()
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    func push(_ process: () -> Void) {
        pushMatrix()
        process()
        popMatrix()
    }
}
