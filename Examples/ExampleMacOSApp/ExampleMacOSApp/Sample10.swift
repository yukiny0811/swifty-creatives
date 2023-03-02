//
//  Sample10.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit

class MyHitTestableRect: HitTestableRect {
    var color: f4 = .zero
}

final class Sample10: Sketch {
    override func setupCamera(camera: some MainCameraBase) {
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
    
    override func mouseMoved(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        let location = mousePos(event: event, viewFrame: viewFrame)
        
        let ray = camera.screenToWorldDirection(x: location.x, y: location.y, width: Float(viewFrame.width), height: Float(viewFrame.height))
        
        for r in rect {
            if let _ = r.hitTestGetPos(origin: ray.origin, direction: ray.direction) {
                r.color = f4(1, 0, 0, 1)
            } else {
                r.color = .one
            }
        }
    }
}
