//
//  Sample5.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import AppKit
import SwiftyCreatives

final class Sample5: Sketch {
    var object = TextObject()
    override init() {
        super.init()
        object
            .setText("Swifty Creatives", font: NSFont.systemFont(ofSize: 60), color: .white)
            .multiplyScale(18)
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        object.draw(0, 0, 0, encoder)
    }
}
