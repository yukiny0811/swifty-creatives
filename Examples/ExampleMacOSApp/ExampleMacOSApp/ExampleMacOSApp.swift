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
                    NavigationLink("1 Blooming Boxes") {
                        Sample1View()
                    }
                    NavigationLink("2 Rectangle") {
                        Sample2View()
                    }
                    NavigationLink("3 Box") {
                        Sample3View()
                    }
                    NavigationLink("4 Colorful Boxes") {
                        Sample4View()
                    }
                    NavigationLink("5 Tree (L-system)") {
                        Sample5View()
                    }
                    NavigationLink("6 Fog") {
                        Sample6View()
                    }
                    NavigationLink("7 Rect with hit test") {
                        Sample7View()
                    }
                    NavigationLink("8 Box with hit test") {
                        Sample8View()
                    }
                    NavigationLink("9 fov") {
                        Sample9View()
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
