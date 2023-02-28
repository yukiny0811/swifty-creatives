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
                SketchView(Sample1())
//                SketchView(Sample2())
//                SketchView(Sample3())
//                SketchView(Sample4())
//                SketchView(Sample5())
//                SketchView(Sample6())
//                SketchView(Sample7())
//                SketchView(Sample8())
//                ConfigurableSketchView<MainCameraConfig, Sample9DrawConfig>(Sample9())
//                SketchView(Sample10())
//                SketchView(Sample11())
//                SketchView(Sample12())
            }
            .background(.black)
        }
    }
}
