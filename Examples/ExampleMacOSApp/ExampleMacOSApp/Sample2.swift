//
//  Sample2.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives

final class Sample2: Sketch {
    var object = Rect()
    override init() {
        super.init()
        object
            .setScale(f3.one * 5)
            .setColor(f4.randomPoint(0...1))
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        object.draw(encoder)
    }
}
