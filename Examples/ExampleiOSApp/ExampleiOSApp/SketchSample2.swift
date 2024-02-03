//
//  SketchSample2.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

import SwiftyCreatives
import UIKit

class RotatingViewObject: UIViewObject {
    @SCAnimatable var rotation: Float = 0
}

final class SketchSample2: Sketch {
    
    let postProcessor = CornerRadiusPostProcessor()
    var viewObj = RotatingViewObject()
    
    override init() {
        super.init()
        let view: TestView = TestView.fromNib(type: TestView.self)
        view.onHit = {
            self.viewObj.rotation += Float.pi / 2
        }
        viewObj.load(view: view)
        viewObj.multiplyScale(6)
        
        let dispatch = EMMetalDispatch()
        dispatch.compute { [weak self] encoder in
            guard let self else { return }
            postProcessor.tex = viewObj.texture
            postProcessor.radius = 50
            postProcessor.dispatch(encoder, textureSizeReference: viewObj.texture!)
        }
        dispatch.commit()
    }
    
    override func update(camera: MainCamera) {
        viewObj.$rotation.update(multiplier: deltaTime * 5)
    }
    
    override func draw(encoder: SCEncoder) {
        rotateZ(viewObj.$rotation.animationValue)
        viewObj.drawWithCache(encoder: encoder, customMatrix: getCustomMatrix())
    }
    
    override func touchesBegan(camera: MainCamera, touchLocations: [f2]) {
        let location = touchLocations.first!
        let processed = camera.screenToWorldDirection(x: location.x, y: location.y)
        let origin = processed.origin
        let direction = processed.direction
        viewObj.buttonTest(origin: origin, direction: direction)
    }
}

class TestView: UIView {
    
    var onHit: (() -> Void)?
    
    @IBAction func onButtonTap() {
        if let onHit = onHit {
            onHit()
        }
    }
}
