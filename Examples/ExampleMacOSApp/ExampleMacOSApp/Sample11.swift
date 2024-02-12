//
//  Sample11.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import SwiftyCreatives
import SwiftUI

struct MyTraceBox {
    var pos: f3
    var color: f4
    var scale: f3
}

class Sample11: RayTraceSketch {
    
    var rotation: Float = 0
    
    var boxes: [MyTraceBox] = {
        var arr: [MyTraceBox] = []
        for _ in 0..<1000 {
            arr.append(
                .init(
                    pos: f3.randomPoint(-7...7),
                    color: f4(
                        Float.random(in: 0...1),
                        Float.random(in: 0...1),
                        Float.random(in: 0...1),
                        1
                    ),
                    scale: f3.randomPoint(0.7...1)
                )
            )
        }
        return arr
    }()
    
    override func updateUniform(uniform: inout RayTracingUniform) {
        rotation += 0.003
        uniform.cameraTransform = .createRotation(angle: rotation, axis: f3(0, 1, 0)) * .createTransform(0, 1, -20)
    }
    
    override func draw() {
        addPointLight(pos: f3(100, 100, 100), color: f3(1, 1, 1), intensity: 1)
        for b in boxes {
            color(b.color.x, b.color.y, b.color.z, b.color.w)
            box(b.pos.x, b.pos.y, b.pos.z, b.scale.x, b.scale.y, b.scale.z)
        }
    }
}

struct Sample11View: View {
    var body: some View {
        RayTraceSketchView(Sample11())
    }
}


