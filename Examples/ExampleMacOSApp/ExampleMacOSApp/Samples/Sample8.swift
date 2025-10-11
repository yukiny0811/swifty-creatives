//
//  Sample8.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit
import SwiftUI

final class Sample8: Sketch {
    
    let box = HitTestableBox().setScale(f3(2, 3, 4))
    var boxColor: f4 = .one
    var testBoxPos: f3 = .zero
    
    override func setupCamera(camera: MainCamera) {
        camera.setTranslate(0, 0, -20)
    }
    
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        color(1, 0, 0, 1)
        box(testBoxPos, f3.one * 0.1)
        translate(0, 3, 0)
        color(boxColor)
        box(box)
    }
    
    override func mouseMoved(camera: MainCamera, location: f2) {
        let ray = camera.screenToWorldDirection(x: location.x, y: location.y)
        if let hitPos = box.hitTest(origin: ray.origin, direction: ray.direction) {
            boxColor = f4(0, 1, 0, 1)
            testBoxPos = hitPos
        } else {
            boxColor = .one
        }
    }
}

struct Sample8View: View {
    var body: some View {
        SketchView(Sample8())
    }
}
