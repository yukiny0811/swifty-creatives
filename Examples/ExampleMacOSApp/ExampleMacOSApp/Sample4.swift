//
//  Sample4.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import Metal
import SwiftyCreatives

final class Sample4: Sketch {
    var object = Triangle()
    override init() {
        super.init()
        object
            .setPos(f3.zero)
            .setScale(f3.one * 5)
            .setColor(f4.randomPoint(0...1))
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: MTLRenderCommandEncoder) {
        object.draw(encoder)
    }
}
