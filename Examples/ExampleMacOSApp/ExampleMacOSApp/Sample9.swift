//
//  Sample9.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/12.
//

import SwiftyCreatives

final class Sample9: Sketch {
    override init() {
        super.init()
    }
    let count = 10
    override func draw(encoder: SCEncoder) {
        setFog(color: f4.one, density: 0.02)
        color(0.8, 0.1, 0.1, 0.8)
        for z in -count...count {
            for y in -count...count {
                for x in -count...count {
                    box(Float(x) * 5, Float(y) * 5, Float(z) * 5, 1, 1, 1)
                }
            }
        }
    }
}
