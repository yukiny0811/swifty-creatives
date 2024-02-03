//
//  FunctionBase+PushPop.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    func pushMatrix() {
        self.customMatrix.append(f4x4.createIdentity())
        setCustomMatrix()
    }
    func popMatrix() {
        let _ = self.customMatrix.popLast()
        setCustomMatrix()
    }
    func push(_ process: () -> Void) {
        pushMatrix()
        process()
        popMatrix()
    }
}
