//
//  SketchSample1.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

import SwiftyCreatives
import UIKit

struct MyBox {
    var pos: f3 = f3.random(in: -7...7)
    var color: f4 = f4.randomPoint(0...1)
    var scale: f3 = f3.one * Float.random(in: 0.3...0.5)
}

final class SketchSample1: Sketch {
    
    var boxes: [MyBox] = []
    var elapsed: Float = 0.0
    
    override init() {
        super.init()
        for _ in 0...100 {
            boxes.append(MyBox())
        }
    }
    
    override func update(camera: MainCamera) {
        camera.rotateAroundY(deltaTime)
        elapsed += deltaTime
    }
    
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        let elapsedSin = sin(elapsed)
        for b in boxes {
            color(elapsedSin, b.color.y, b.color.z, b.color.w)
            pushMatrix()
            box(b.pos, b.scale)
            popMatrix()
        }
    }
    
    override func touchesBegan(camera: MainCamera, touchLocations: [f2]) {
        let location = touchLocations.first!
        let processed = camera.screenToWorldDirection(x: location.x, y: location.y)
        let origin = processed.origin
        let direction = processed.direction
        let finalPos = origin + direction * 20
        
        var box = MyBox()
        box.color = f4.one
        box.pos = finalPos
        box.scale = f3.one * 0.2
        boxes.append(box)
    }
}
