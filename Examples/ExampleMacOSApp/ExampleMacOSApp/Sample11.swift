//
//  Sample11.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import SwiftyCreatives
import SwiftUI

class Sample11: RayTraceSketch {
    var rotation: Float = 0
    override func updateUniform(uniform: inout RayTracingUniform) {
        rotation += 0.003
        uniform.cameraTransform = .createRotation(angle: rotation, axis: f3(0, 1, 0)) * .createTransform(0, 1, -20)
    }
    override func draw() {
        
        for _ in 0..<1000 {
            color(
                Float.random(in: 0...1),
                Float.random(in: 0...1),
                Float.random(in: 0...1),
                1
            )
            box(
                Float.random(in: -7...7),
                Float.random(in: -7...7),
                Float.random(in: -7...7),
                Float.random(in: 0.1...0.2),
                Float.random(in: 0.1...0.2),
                Float.random(in: 0.1...0.2)
            )
        }
        print("finish static")
    }
}

struct Sample11View: View {
    var body: some View {
        RayTraceSketchView(Sample11())
    }
}


