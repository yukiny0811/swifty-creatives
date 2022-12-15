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
                MetalView<MySketch, MainCameraConfig, MainDrawConfig>()
            }
            .background(.black)
        }
    }
}

final class MySketch: SketchBase {
    var boxes: [Box] = []
    var elapsed: Float = 0
    func setup() {
        for _ in 0..<1000 {
            let box = Box(pos: f3.randomPoint(-1000...1000))
            box.setColor(
                Float.random(in: 0...1),
                Float.random(in: 0...0.5),
                Float.random(in: 0...0.5),
                Float.random(in: 0...1)
            )
            boxes.append(box)
        }
    }
    func update() {
        for b in boxes {
            b.setColor(
                sin(elapsed),
                b.getColor().y,
                b.getColor().z,
                b.getColor().w
            )
        }
        elapsed += 0.01
    }
    
    func cameraProcess(camera: SwiftyCreatives.MainCamera<some SwiftyCreatives.CameraConfigBase>) {
        camera.rotateAroundY(0.01)
    }
    
    func draw(encoder: MTLRenderCommandEncoder) {
        for b in boxes {
            b.draw(encoder)
        }
    }
}
