//
//  Sample6.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives

class MyBox {
    var pos: f3
    var color: f4
    var scale: f3
    init(pos: f3, color: f4, scale: f3) {
        self.pos = pos
        self.color = color
        self.scale = scale
    }
}

final class Sample6: Sketch {
    var objects: [MyBox] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = MyBox(
                pos: f3.randomPoint(-7...7),
                color: f4.randomPoint(0...1),
                scale: f3.randomPoint(1...2)
            )
            objects.append(box)
        }
    }
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        for o in objects {
            color(o.color)
            box(o.pos, o.scale)
        }
    }
}
