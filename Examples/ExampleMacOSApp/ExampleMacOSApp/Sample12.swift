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
    @SCAnimatable var height: Float = 0
    func reset() {
        height = Float.random(in: 1...13)
    }
}

final class Sample12: Sketch {
    
    let numberFactory = NumberImageTextFactory(font: NSFont.systemFont(ofSize: 60), color: .white)
    let textFactory = GeneralImageTextFactory(font: NSFont.systemFont(ofSize: 60), register: "someTextFrameRate:" + ImageTextFactory.Template.numerics, color: .white)
    
    static let count = 6
    static let multiplier: Float = 5
    var boxes: [[ColoredHitTestableBox]] = []
    
    override init() {
        for _ in 0...Self.count {
            var array: [ColoredHitTestableBox] = []
            for _ in 0...Self.count {
                let box = ColoredHitTestableBox()
                box.saveColor = f4(0.0, Float.random(in: 0.1...0.7), Float.random(in: 0.1...0.7), 1)
                array.append(box)
            }
            boxes.append(array)
        }
    }
    
    override func setupCamera(camera: MainCamera) {
        camera.setTranslate(0, 0, -30)
    }
    
    override func update(camera: MainCamera) {
        for x in 0...Self.count {
            for y in 0...Self.count {
                boxes[x][y].$height.update(multiplier: deltaTime * 8)
            }
        }
    }
    
    override func draw(encoder: SCEncoder) {
        pushMatrix()
        translate(-15, -15, -15)
        for x in 0...Self.count {
            for y in 0...Self.count {
                pushMatrix()
                translate(Float(x) * Self.multiplier, 0, Float(y) * Self.multiplier)
                boxes[x][y].setScale(f3(1.5, boxes[x][y].$height.animationValue, 1.5))
                translate(0, boxes[x][y].scale.y, 0)
                color(boxes[x][y].saveColor)
                drawHitTestableBox(box: boxes[x][y])
                translate(0, boxes[x][y].scale.y + 1, 0)
                drawNumberText(encoder: encoder, factory: numberFactory, number: Float(Int(boxes[x][y].$height.animationValue*10))/10)
                translate(0, 1.5, 0)
                drawGeneralText(encoder: encoder, factory: textFactory, text: "some Texts", spacing: 0.3, scale: 0.5, spacer: 0.7)
                popMatrix()
            }
        }
        popMatrix()
        translate(0, 15, 0)
        drawGeneralText(encoder: encoder, factory: textFactory, text: "FrameRate: \(Int(frameRate))")
    }
    
    override func mouseMoved(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {
        var location = mousePos(event: event, viewFrame: viewFrame)
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
            }
        }
        if let savedIndex = savedIndex {
            boxes[savedIndex.0][savedIndex.1].saveColor = f4(1, 1, 0, 1)
        }
    }
    
    override func keyDown(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {
        if event.keyCode == 49 {
            for x in 0...Self.count {
                for y in 0...Self.count {
                    boxes[x][y].reset()
                }
            }
        }
    }
}
