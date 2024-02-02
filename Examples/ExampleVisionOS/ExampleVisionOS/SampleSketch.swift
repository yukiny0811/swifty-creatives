//
//  SampleSketch.swift
//  ExampleVisionOS
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import SwiftyCreatives

final class SampleSketch: Sketch {
    
    let count = 5
    
    override func draw(encoder: SCEncoder) {
        setFog(color: f4.one, density: 0.02)
        color(0.8, 0.1, 0.5, 0.8)
        for z in -count...count {
            for y in -count...count {
                for x in -count...count {
                    if x == 0 && y == 0 && z == 0 {
                        continue
                    }
                    box(Float(x) * 15, Float(y) * 15, Float(z) * 15, 1, 1, 1)
                }
            }
        }
    }
}
