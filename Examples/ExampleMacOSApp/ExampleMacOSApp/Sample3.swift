//
//  Sample3.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives

final class Sample3: Sketch {
    override init() {
        super.init()
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        color(f4.randomPoint(0...1))
        box(f3.one * 5)
    }
}
