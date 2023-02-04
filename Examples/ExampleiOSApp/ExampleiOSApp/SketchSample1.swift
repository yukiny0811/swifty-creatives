//
//  SketchSample1.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

import SwiftyCreatives
import UIKit

final class SketchSample1: Sketch {
    
    var boxes: [Box] = []
    var elapsed: Float = 0.0
    
    override init() {
        super.init()
        for _ in 0...100 {
            let box = Box()
            box.setColor(f4.randomPoint(0...1))
            box.setPos(f3.randomPoint(-7...7))
            box.setScale(f3.one * Float.random(in: 0.3...0.5))
            boxes.append(box)
        }
    }
    
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
        elapsed += 0.01
        let elapsedSin = sin(elapsed)
        for b in boxes {
            b.setColor(f4(elapsedSin, b.color.y, b.color.z, b.color.w))
        }
    }
    
    override func draw(encoder: SCEncoder) {
        for b in boxes {
            b.draw(encoder)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {
        let touch = touches.first!
        let location = touch.location(in: view)
        let processed = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(view.frame.width), height: Float(view.frame.height))
        let origin = processed.origin
        let direction = processed.direction
        let finalPos = origin + direction * 20
        
        let box = Box()
        box.setColor(f4(1, 1, 1, 1))
        box.setPos(finalPos)
        box.setScale(f3.one * 0.2)
        boxes.append(box)
    }
}
