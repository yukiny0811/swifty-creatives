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
                SketchView<MainCameraConfig, MainDrawConfig>(Sample1())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample2())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample3())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample4())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample5())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample6())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample7())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample8())
//                SketchView<MainCameraConfig, Sample9DrawConfig>(Sample9())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample10())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample11())
//                SketchView<MainCameraConfig, MainDrawConfig>(Sample12())
            }
            .background(.black)
        }
    }
}
