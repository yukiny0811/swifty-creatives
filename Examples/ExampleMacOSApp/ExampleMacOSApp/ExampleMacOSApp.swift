//
//  ExampleMacOSApp.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

import SwiftUI
import SwiftyCreatives

@main
struct ExampleMacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Text("Swifty-Creatives Example")
                    .font(.largeTitle)
                VStack {
                    HStack {
                        SketchView<MainCameraConfig, MainDrawConfig>(MySketch())
                        SketchView<MainCameraConfig, MainDrawConfig>(MySketch())
                        SketchView<MainCameraConfig, MainDrawConfig>(MySketch())
                    }
                    HStack {
                        SketchView<MainCameraConfig, MyDrawConfigNormal>(MySketch())
                        SketchView<MainCameraConfig, MyDrawConfigAdd>(MySketch())
                        SketchView<MainCameraConfig, MyDrawConfigAlpha>(MySketch())
                    }
                }
            }
            .background(.black)
        }
    }
}

final class MyDrawConfigNormal: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .normalBlend
}

final class MyDrawConfigAdd: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .add
}

final class MyDrawConfigAlpha: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .alphaBlend
}

final class MySketch: Sketch {

    var boxes: [Box] = []
    var elapsed: Float = 0.0
    
    override init() {
        super.init()
        for _ in 0...100 {
            let box = Box()
            box.setColor(f4.randomPoint(0...1))
            box.setPos(f3.randomPoint(-7...7))
            box.setScale(f3.one * Float.random(in: 0.3...2))
            boxes.append(box)
        }
    }

    override func setupCamera(camera: some MainCameraBase) {}

    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
        elapsed += 0.01
        for b in boxes {
            b.setColor(f4(sin(elapsed), b.color.y, b.color.z, b.color.w))
        }
    }

    override func draw(encoder: MTLRenderCommandEncoder) {
        for b in boxes {
            b.draw(encoder)
        }
    }
    
    override func mouseDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        
        let location = CGPoint(
            x: event.locationInWindow.x - viewFrame.origin.x,
            y: event.window!.frame.height - event.locationInWindow.y - viewFrame.origin.y
        )
        
        let processed = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(viewFrame.width), height: Float(viewFrame.height))
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
