//
//  FunctionBase+Fog.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    func setFog(color: f4, density: Float) {
        setFogDensity(density)
        setFogColor(color)
    }
}
