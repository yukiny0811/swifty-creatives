//
//  Sample3.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2023/02/13.
//

//
//  SketchSample1.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

import SwiftyCreatives
import UIKit

final class Sample3: Sketch {
    
    var imageObjects: [UIViewObject] = []
    
    override init() {
        super.init()
        for i in 0..<1 {
            let view: TestView = TestView.fromNib(type: TestView.self)
            view.onHit = {
                print("wow" + String(i))
            }
            let obj = UIViewObject()
                .setPos(f3.zero)
                .setRot(f3.zero)
                .setColor(f4.one)
            obj.load(view: view)
            obj.multiplyScale(6)
            imageObjects.append(obj)
        }
    }
    
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, 0, -50)
    }
    
    override func draw(encoder: SCEncoder) {
        for obj in imageObjects {
            rotateY(0.0)
            translate(0, 6, 0)
            pushMatrix()
            translate(0, 0, 10)
            obj.drawWidthCache(encoder, customMatrix: getCustomMatrix())
            popMatrix()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {
        let touch = touches.first!
        let location = touch.location(in: view)
        let processed = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(view.frame.width), height: Float(view.frame.height))
        let origin = processed.origin
        let direction = processed.direction
        for obj in imageObjects {
            obj.calculateHitTest(origin: origin, direction: direction, testDistance: 3000, customMatrix: obj.cacheCustomMatrix)
        }
    }
}

