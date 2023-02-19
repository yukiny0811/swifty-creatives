//
//  Sample7.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import AppKit
import SwiftyCreatives

final class Sample7: Sketch {
    
    var boxes: [Box] = []
    var elapsed: Float = 0.0
    var text = TextObject()
    
    override init() {
        for _ in 0...8 {
            let box = Box()
                .setColor(f4.randomPoint(0...1))
                .setScale(f3.one * Float.random(in: 0.1...0.5))
            boxes.append(box)
        }
        text
            .setText("Loading...", font: NSFont.systemFont(ofSize: 120), color: .white)
            .multiplyScale(7)
        
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.03)
        for i in 0..<boxes.count {
            let elapsedSin = sin(elapsed * Float(i+1))
            let elapsedCos = cos(elapsed * Float(i+1))
            boxes[i]
                .setColor(f4(elapsedSin, boxes[i].color.y, boxes[i].color.z, 1))
        }
        elapsed += 0.01
    }
    
    override func draw(encoder: SCEncoder) {
        for i in 0..<boxes.count {
            pushMatrix()
            let elapsedSin = sin(elapsed * Float(i+1))
            let elapsedCos = cos(elapsed * Float(i+1))
            translate(elapsedCos * 5, elapsedSin * 5, 0)
            boxes[i].draw(encoder)
            popMatrix()
        }
        text.draw(0, 0, 0, encoder)
    }
}
