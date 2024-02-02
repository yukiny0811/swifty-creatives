//
//  Sample7.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import AppKit
import SwiftyCreatives

final class Sample7: Sketch {
    
    var colors: [f4] = []
    var scales: [f3] = []
    var elapsed: Float = 0.0
    var text = TextObject()
    
    override init() {
        for _ in 0...8 {
            colors.append(f4.randomPoint(0...1))
            scales.append(f3.one * Float.random(in: 0.1...0.5))
        }
        text
            .setText("Loading...", font: NSFont.systemFont(ofSize: 120))
            .multiplyScale(5)
        
    }
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.03)
        elapsed += 0.01
    }
    
    override func draw(encoder: SCEncoder) {
        for i in 0..<8 {
            let elapsedSin = sin(elapsed * Float(i+1))
            let elapsedCos = cos(elapsed * Float(i+1))
            color(elapsedSin, colors[i].y, colors[i].z)
            pushMatrix()
            translate(elapsedCos * 5, elapsedSin * 5, 0)
            box(scales[i])
            popMatrix()
        }
        text(text)
    }
}
