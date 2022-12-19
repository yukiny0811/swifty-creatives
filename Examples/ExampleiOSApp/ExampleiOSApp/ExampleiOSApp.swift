//
//  ExampleiOSApp.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

import SwiftUI
import SwiftyCreatives

@main
struct ExampleiOSApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Text("Swifty-Creatives Example")
                    .font(.largeTitle)
                VStack {
                    HStack {
                        SketchView<MySketch, MainCameraConfig, MainDrawConfig>()
                        SketchView<MySketch, MainCameraConfig, MyDrawConfigNormal>()
                    }
                    HStack {
                        SketchView<MySketch, MainCameraConfig, MyDrawConfigAdd>()
                        SketchView<MySketch, MainCameraConfig, MyDrawConfigAlpha>()
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

final class MySketch: SketchBase {
    
    var boxes: [Box] = []
    var elapsed: Float = 0.0
    
    func setup() {
        for _ in 0...100 {
            let box = Box()
            box.setColor(f4.randomPoint(0...1))
            box.setPos(f3.randomPoint(-7...7))
            box.setScale(f3.one * Float.random(in: 0.3...1.5))
            boxes.append(box)
        }
    }
    func update() {
        let elapsedSin = sin(elapsed)
        for b in boxes {
            b.setColor(f4(elapsedSin, b.color.y, b.color.z, b.color.w))
        }
        elapsed += 0.01
    }
    
    func cameraProcess(camera: MainCamera<some CameraConfigBase>) {
        camera.rotateAroundY(0.01)
    }
    
    func draw(encoder: MTLRenderCommandEncoder) {
        for b in boxes {
            b.draw(encoder)
        }
    }
}
