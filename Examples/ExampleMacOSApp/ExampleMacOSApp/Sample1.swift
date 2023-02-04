//
//  Sample1.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives

final class Sample1: Sketch {
    override func draw(encoder: SCEncoder) {
        let count = 20
        for i in 0...count {
            color(1, Float(i) / 20, 0, 1, encoder: encoder)
            pushMatrix(encoder: encoder)
            rotateY(Float.pi * 2 / Float(count) * Float(i), encoder: encoder)
            translate(10, 0, 0, encoder: encoder)
            box(0, 0, 0, 1, 1, 1, encoder: encoder)
            popMatrix(encoder: encoder)
        }
    }
}
