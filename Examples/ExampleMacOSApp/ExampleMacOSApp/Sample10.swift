//
//  Sample10.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import SwiftyCreatives
import SwiftUI

class Sample10: Sketch {
    
    let swiftTextObj = Text2D(
        text: "Swifty\nCreatives",
        fontName: "Avenir-BlackOblique",
        fontSize: 10
    )
    
    override func draw(encoder: SCEncoder) {
        color(1)
        text(swiftTextObj)
    }
}

struct Sample10View: View {
    var body: some View {
        SketchView(Sample10())
    }
}
