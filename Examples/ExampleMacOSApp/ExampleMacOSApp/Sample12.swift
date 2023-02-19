//
//  Sample12.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import SwiftyCreatives
import CoreGraphics
import AppKit
import simd

class ColoredHitTestableBox: HitTestableBox {
    var saveColor: f4 = .zero
}

final class Sample12: Sketch {
    
    static let count = 6
    static let multiplier: Float = 5
    var boxes: [[ColoredHitTestableBox]] = []
    var texts: [[TextObject]] = []
    
    override init() {
        for _ in 0...Self.count {
            var array: [ColoredHitTestableBox] = []
            var textarray: [TextObject] = []
            for _ in 0...Self.count {
                let height: Float = Float.random(in: 1...7)
                
                let box = ColoredHitTestableBox()
                    .setScale(f3(1.5, height, 1.5))
                box.saveColor = f4(0.0, Float.random(in: 0.1...0.7), Float.random(in: 0.1...0.7), 1)
                box.setColor(box.saveColor)
                array.append(box)
                
                let text = TextObject()
                    .setText(String(Int(height)) + ".0", font: .systemFont(ofSize: 60), color: .white)
                    .multiplyScale(0.7)
                textarray.append(text)
            }
            boxes.append(array)
            texts.append(textarray)
        }
    }
    
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, 0, -30)
    }
    
    override func draw(encoder: SCEncoder) {
        translate(-15, 0, -15)
        for x in 0...Self.count {
            for y in 0...Self.count {
                pushMatrix()
                translate(Float(x) * Self.multiplier, 0, Float(y) * Self.multiplier)
                translate(0, boxes[x][y].scale.y, 0)
                drawHitTestableBox(box: boxes[x][y])
                
                translate(0, boxes[x][y].scale.y + 1, 0)
                texts[x][y].draw(0, 0, 0, encoder)
                popMatrix()
            }
        }
    }
    
    override func mouseMoved(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        var location = event.locationInWindow
        location.y = viewFrame.height - location.y
        let ray = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(viewFrame.width), height: Float(viewFrame.height))
        
        var savedIndex: (Int, Int)? = nil
        var closestDistance: Float = 10000
        for i in 0..<boxes.count {
            for j in 0..<boxes[i].count {
                if let hitPos = boxes[i][j].hitTest(origin: ray.origin, direction: ray.direction) {
                    if simd_distance(hitPos, ray.origin) < closestDistance {
                        closestDistance = simd_distance(hitPos, ray.origin)
                        savedIndex = (i, j)
                    }
                }
                boxes[i][j].setColor(boxes[i][j].saveColor)
            }
        }
        if let savedIndex = savedIndex {
            boxes[savedIndex.0][savedIndex.1].setColor(f4(1, 1, 0, 1))
        }
    }
}
