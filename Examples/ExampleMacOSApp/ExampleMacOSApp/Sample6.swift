//
//  Sample6.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives

final class Sample6: Sketch {
    var objects: [Box] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = Box()
                .setColor(f4.randomPoint(0...1))
                .setScale(f3.randomPoint(1...2))
            objects.append(box)
        }
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        for o in objects {
            pushMatrix()
            translate(Float.random(in: -7...7), Float.random(in: -7...7), Float.random(in: -7...7))
            o.draw(encoder)
            popMatrix()
        }
    }
}
