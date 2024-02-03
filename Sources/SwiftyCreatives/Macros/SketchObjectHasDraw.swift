//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import Foundation

public protocol SketchObjectHasDraw: FunctionBase {
    func draw()
}

public extension SketchObjectHasDraw {
    func draw(encoder: SCEncoder, customMatrix: f4x4) {
        self.privateEncoder = encoder
        self.customMatrix = [customMatrix]
        draw()
    }
}
