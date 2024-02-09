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
        for z in -count...count {
            for y in -count...count {
                for x in -count...count {
                    if x == 0 && y == 0 && z == 0 {
                        continue
                    }
                    let r = Float(x + count) / Float(count * 2)
                    let g = Float(y + count) / Float(count * 2)
                    let b = Float(z + count) / Float(count * 2)
                    color(r, g, b, 0.1)
                    box(Float(x) * 1, Float(y) * 1, Float(z) * 1, 0.1, 0.1, 0.1)
                }
            }
        }
    }
}
