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
        for i in 0..<count {
            color(1, Float(i) / 40, 0, 0.5)
            pushMatrix()
            rotateY(Float.pi * 2 / Float(count) * Float(i))
            translate(10, 0, 0)
            box(0, 0, 0, 1, 1, 1)
            popMatrix()
        }
    }
}
