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
                        SketchView<SketchSample1, MainCameraConfig, MainDrawConfig>()
                        SketchView<SketchSample1, MainCameraConfig, MyDrawConfigNormal>()
                    }
                    HStack {
                        SketchView<SketchSample2, MainCameraConfig, MyDrawConfigAdd>()
                        SketchView<SketchSample2, MainCameraConfig, MyDrawConfigAlpha>()
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
