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
    
    var circle = Circ()

    override init() {
        super.init()
//        for i in 0..<100 {
//            let box = Box()
//            box.setPos(f3.randomPoint(-100...100))
//            box.setColor(f4.randomPoint(0...1))
//            box.setScale(f3.randomPoint(10...100))
//            boxes.append(box)
//        }
        
        circle.setPos(f3.zero)
        circle.setScale(f3.one * 10)
        circle.setColor(f4.randomPoint(0...1))
    }

    override func setupCamera(camera: some MainCameraBase) {
//        camera.setTranslate(0, 0, -20)
    }

    override func update(camera: some MainCameraBase) {}

    override func draw(encoder: MTLRenderCommandEncoder) {

//        for b in boxes {
//            b.draw(encoder)
//        }
        
        circle.draw(encoder)
    }
}


//final class MySketch: Sketch {
//
//    var text = TextObject()
//    var img = Img()
//    var model = ModelObject()
//
//    override init() {
//        super.init()
//        text.setText("hello", font: NSFont.systemFont(ofSize: 120), color: NSColor(red: 1, green: 1, blue: 0, alpha: 1))
//        text.multiplyScale(10)
//
//        img.load(image: NSImage(named: "kkkkk")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
//        img.multiplyScale(10)
//        img.setPos(f3(0, 0, 3))
//        img.setColor(f4.one)
//
//        model.loadModel(name: "depse", extensionName: "obj")
//        model.multiplyScale(5)
//    }
//
//    override func setupCamera(camera: some MainCameraBase) {}
//
//    override func update(camera: some MainCameraBase) {}
//
//    override func draw(encoder: MTLRenderCommandEncoder) {
//
//        text.draw(0, 0, 0, encoder)
//
//        img.draw(encoder)
//        model.draw(encoder)
//
//        color(1, 1, 0, 1, encoder: encoder)
//        box(0, 0, 3, 3, 4, 1, encoder: encoder)
//        color(1, 0, 1, 0.5, encoder: encoder)
//        rect(0, 0, 0, 7, 8, encoder: encoder)
//    }
//}
