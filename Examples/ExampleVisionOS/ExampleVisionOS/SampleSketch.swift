//
//  SampleSketch.swift
//  ExampleVisionOS
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

import SwiftyCreatives

@SketchObject
class MyBox {
    var pos: f3
    var col: f4
    var scale: f3
    init(pos: f3, col: f4, scale: f3) {
        self.pos = pos
        self.col = col
        self.scale = scale
    }
    func draw() {
        color(col)
        box(pos, scale)
    }
}

final class SampleSketch: Sketch {
    var objects: [MyBox] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = MyBox(
                pos: f3.randomPoint(-1...1),
                col: f4.randomPoint(0...1),
                scale: f3.randomPoint(0.05...0.1)
            )
            objects.append(box)
        }
    }
    override func draw(encoder: SCEncoder) {
        translate(0, 0, -3)
        for o in objects {
            o.draw(encoder: encoder, customMatrix: getCustomMatrix())
        }
    }
}
