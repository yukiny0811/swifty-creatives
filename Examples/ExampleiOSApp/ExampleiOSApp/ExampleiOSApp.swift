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
                VStack {
                    HStack {
                        SketchView<MainCameraConfig, MainDrawConfig>(SketchSample1())
                        SketchView<MainCameraConfig, MyDrawConfigNormal>(SketchSample1())
                    }
                    HStack {
                        SketchView<MainCameraConfig, MyDrawConfigAdd>(SketchSample2())
                        SketchView<MainCameraConfig, MyDrawConfigAlpha>(SketchSample2())
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
