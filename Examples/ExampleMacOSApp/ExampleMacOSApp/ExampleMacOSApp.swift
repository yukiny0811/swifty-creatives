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
                MetalView<MySketch, MainCameraConfig, MyDrawConfig>()
            }
            .background(.black)
        }
    }
}

final class MyDrawConfig: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .normalBlend
    static var sketchMode: SketchMode = .simple
}

final class MySketch: Sketch {
    
    let b1 = Box()
    let b2 = Box()
    
    override func setup() {
        setColor(f4(1, 0, 0, 1))
        setPos(f3.zero)
        setRot(f3.zero)
        setScale(f3.one)
    }
    override func update() {
    }
    
    override func cameraProcess(camera: MainCamera<some CameraConfigBase>) {
        
    }
    
    override func draw(encoder: MTLRenderCommandEncoder) {
        
        setPos(f3(10, 0, 10))
        setColor(f4(1, 1, 0, 1))
        b1.draw(encoder, pass)
        
        setPos(f3(10, 10, 0))
        setColor(f4(1, 0, 1, 1))
        b2.draw(encoder, pass)
    }
}
