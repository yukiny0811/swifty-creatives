//
//  Sample10.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import SwiftyCreatives
import SwiftUI

class Sample10: Sketch {
    
    var swiftTextObj: Text2D = Text2D(
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
    
    let sketch = Sample10()
    
    var body: some View {
        SketchView(sketch)
            .toolbar {
                ToolbarItem {
                    Menu("Font") {
                        ForEach(getAvailableFonts(), id: \.self) { font in
                            Button(font) {
                                sketch.swiftTextObj = Text2D(
                                    text: "Swifty\nCreatives",
                                    fontName: font,
                                    fontSize: 10
                                )
                            }
                        }
                    }
                }
            }
    }
    
    func getAvailableFontFamilies() -> [String] {
        return NSFontManager.shared.availableFontFamilies
    }

    func getAvailableFonts() -> [String] {
        return NSFontManager.shared.availableFonts
    }
}
