//
//  FunctionBase+Fog.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    static func setFog(_ encoder: MTLRenderCommandEncoder?, color: f4, density: Float) {
        Self.setFogDensity(encoder, density)
        Self.setFogColor(encoder, color)
    }
}
