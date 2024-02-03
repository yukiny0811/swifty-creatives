//
//  Sample3.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives
import SwiftUI

final class Sample3: Sketch {
    
    var c = f4(1, 0.5, 1, 1)
    
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.01)
    }
    
    override func draw(encoder: SCEncoder) {
        color(c)
        box(f3.one * 5)
    }
}

struct Sample3View: View {
    var body: some View {
        SketchView(Sample3())
    }
}
