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
                SketchView(SketchSample1())
//                SketchView(SketchSample2())
            }
            .background(.black)
        }
    }
}
