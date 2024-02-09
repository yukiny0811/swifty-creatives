//
//  Sample11.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import SwiftyCreatives
import SwiftUI

class Sample11: RayTraceSketch {
    override func updateUniform(uniform: inout RayTracingUniform) {
        uniform.cameraTransform = .createRotation(angle: 0.3, axis: f3(0, 1, 0)) * .createTransform(0, 1, -10)
    }
    override func createStaticScene() {
        
        for _ in 0..<100 {
            color(
                Float.random(in: 0...1),
                Float.random(in: 0...1),
                Float.random(in: 0...1),
                1
            )
            rect(
                Float.random(in: -7...7),
                Float.random(in: -7...7),
                Float.random(in: -7...7),
                Float.random(in: 0.1...1),
                Float.random(in: 0.1...1)
            )
        }
    }
}

struct Sample11View: View {
    var body: some View {
        RayTraceSketchView(Sample11())
    }
}


