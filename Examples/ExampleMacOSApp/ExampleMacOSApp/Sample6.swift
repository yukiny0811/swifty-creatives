//
//  Sample6.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import Metal
import SwiftyCreatives

final class Sample6: Sketch {
    var objects: [Box] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = Box()
            box.setPos(f3.randomPoint(-7...7))
            box.setColor(f4.randomPoint(0...1))
            box.setScale(f3.randomPoint(1...2))
            objects.append(box)
        }
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: MTLRenderCommandEncoder) {
        for o in objects {
            o.draw(encoder)
        }
    }
}
