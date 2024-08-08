//
//  Sample7.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit
import SwiftUI

class MyHitTestableRect: HitTestableRect {
    var color: f4 = .zero
}

final class Sample7: Sketch {
    override func setupCamera(camera: MainCamera) {
        camera.setTranslate(0, 0, -10)
    }
    var rect: [MyHitTestableRect] = [
        MyHitTestableRect(),
        MyHitTestableRect(),
        MyHitTestableRect()
    ]
    override func draw(encoder: SCEncoder) {
        for r in rect {
            translate(0, 3, 0)
            rotateY(0.3)
            color(r.color)
            r.drawWithCache(encoder: encoder, customMatrix: getCustomMatrix())
        }
    }
    
    override func mouseMoved(camera: MainCamera, location: f2) {
        
        let ray = camera.screenToWorldDirection(x: location.x, y: location.y)
        
        for r in rect {
            if let _ = r.hitTestGetPos(origin: ray.origin, direction: ray.direction) {
                r.color = f4(1, 0.5, 1, 1)
            } else {
                r.color = .one
            }
        }
    }
}

struct Sample7View: View {
    var body: some View {
        SketchView(Sample7())
    }
}
