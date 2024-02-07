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
    override func draw() {
        color(1, 0, 0, 1)
        box(0, 0, 0, 1, 1, 1)
        
        color(0, 0, 1, 1)
        box(-3, 0, 0, 0.4, 0.4, 0.4)
    }
}

struct Sample11View: View {
    var body: some View {
        RayTraceSketchView(Sample11())
    }
}


