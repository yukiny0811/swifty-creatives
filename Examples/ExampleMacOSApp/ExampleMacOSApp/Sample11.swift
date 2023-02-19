//
//  Sample11.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit

final class Sample11: Sketch {
    let box = HitTestableBox().setPos(f3(0, 0, 1)).setScale(f3.one * 2)
    
    let testBox = Box().setColor(f4(1, 0, 0, 1)).setScale(f3.one * 0.1)
    
    let rect = Rect().setPos(f3(0, 0, 2)).setScale(f3.one * 1)
    
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, 0, -10)
    }
    
    override func draw(encoder: SCEncoder) {
        
        testBox.draw(encoder)
        
        rotateY(0.3)
        translate(0, 3, 0)
        rotateZ(0.5)
        translate(2, 0, 0)
//        box.drawWithCache(encoder, customMatrix: getCustomMatrix())
        rect.drawWithCache(encoder: encoder, customMatrix: getCustomMatrix())
    }
    
    override func mouseMoved(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        var location = event.locationInWindow
        location.y = viewFrame.height - location.y

        let ray = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(viewFrame.width), height: Float(viewFrame.height))

//        if let hitPos = box.hitTest(origin: ray.origin, direction: ray.direction) {
//            box.setColor(f4(0, 0, 1, 1))
//            testBox.setPos(hitPos)
//        } else {
//            box.setColor(f4.one)
//        }
        
        if let hitPos = rect.hitTestGetPos(origin: ray.origin, direction: ray.direction) {
            rect.setColor(f4(0, 0, 1, 1))
        } else {
            rect.setColor(f4.one)
        }
    }
}
