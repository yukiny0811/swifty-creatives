//
//  Sample10.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit

final class Sample10: Sketch {
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, 0, -10)
    }
    var rect: [Rect] = [
        Rect().setColor(f4.one),
        Rect().setColor(f4.one),
        Rect().setColor(f4.one)
    ]
    override func draw(encoder: SCEncoder) {
        for r in rect {
            translate(0, 3, 0)
            rotateY(0.3)
            r.drawWithCache(encoder: encoder, customMatrix: getCustomMatrix())
        }
    }
    
    override func mouseMoved(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        var location = event.locationInWindow
        location.y = viewFrame.height - location.y
        
        let ray = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(viewFrame.width), height: Float(viewFrame.height))
        
        for r in rect {
            if let _ = r.hitTestGetPos(origin: ray.origin, direction: ray.direction) {
                r.setColor(f4(1, 0, 0, 1))
            } else {
                r.setColor(f4.one)
            }
        }
    }
}
