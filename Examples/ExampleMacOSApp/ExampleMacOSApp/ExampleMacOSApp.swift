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
            NavigationSplitView {
                List {
                    NavigationLink("Sample1: Blooming Boxes") {
                        Sample1View()
                    }
                    NavigationLink("Sample2: Rectangle") {
                        Sample2View()
                    }
                    NavigationLink("Sample3: Box") {
                        Sample3View()
                    }
                    NavigationLink("Sample4: Colorful Boxes") {
                        Sample4View()
                    }
                    NavigationLink("Sample5: Tree (L-system)") {
                        Sample5View()
                    }
                    NavigationLink("Sample6: Fog") {
                        Sample6View()
                    }
                    NavigationLink("Sample7: Rect with hit test") {
                        Sample7View()
                    }
                    NavigationLink("Sample8: Box with hit test") {
                        Sample8View()
                    }
                }
            } detail: {
                Text("Choose sample sketch from the sidebar")
                    .foregroundStyle(.white)
            }
            .background(.black)
        }
    }
}
