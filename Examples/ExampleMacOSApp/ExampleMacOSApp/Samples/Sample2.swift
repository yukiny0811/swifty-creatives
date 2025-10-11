//
//  Sample2.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives
import SwiftUI

final class Sample2: Sketch {
    
    var c: f4 = .init(1, 0.5, 1, 1)
    
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.01)
    }
    
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        color(c)
        rect(f3.one * 5)
    }
}

struct Sample2View: View {
    var body: some View {
        SketchView(Sample2())
    }
}
