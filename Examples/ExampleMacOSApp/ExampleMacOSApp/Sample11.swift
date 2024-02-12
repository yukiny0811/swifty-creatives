//
//  Sample11.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

import SwiftyCreatives
import SwiftUI

final class Sample11: RayMarchSketch {
    
    var rot: Float = 0.0
    
    override func updateUniform(uniform: inout RayMarchUniform) {
        rot += 0.01
        uniform.cameraTransform = .createRotation(angle: rot, axis: f3(0, 1, 0)) * .createTransform(0, 0, -10)
    }
    override func draw() {
        print(frameRate)
        
        translate(0, 0, 0)
        sphere(radius: 2)
        
        translate(2, 0, 0)
        box(1, 1.5, 2)
    }
}

struct Sample11View: View {
    let sketch = Sample11()
    var body: some View {
        RayMarchSketchView(sketch)
    }
}
