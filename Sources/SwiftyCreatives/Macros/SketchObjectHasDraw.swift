//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import Metal

public protocol SketchObjectHasDraw: HasSketchFunctions {
    func draw()
}

public extension SketchObjectHasDraw {
    func draw(encoder: MTLRenderCommandEncoder, customMatrix: f4x4) {
        self.encoder = encoder
        self.customMatrix = [customMatrix]
        draw()
    }
}
