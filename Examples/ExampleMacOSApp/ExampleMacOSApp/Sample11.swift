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
    var roughness: Float
    var metallic: Float
}

class Sample11: RayTraceSketch {
    
    var rotation: Float = 0
    
    var boxes: [MyTraceBox] = {
        var arr: [MyTraceBox] = []
        for _ in 0..<30 {
            arr.append(
                .init(
                    pos: f3.randomPoint(-7...7),
                    color: f4(
                        Float.random(in: 0...1),
                        Float.random(in: 0...1),
                        Float.random(in: 0...1),
                        1
                    ),
                    scale: f3.randomPoint(1.0...1.4),
                    roughness: Float.random(in: 0...1),
                    metallic: Float.random(in: 0...1)
                )
            )
        }
        return arr
    }()
    
    override func updateUniform(uniform: inout RayTracingUniform) {
        rayTraceConfig.sampleCount = 300
        rayTraceConfig.bounceCount = 2
        rotation += 0.02
        uniform.cameraTransform = .createRotation(angle: rotation, axis: f3(0, 1, 0)) * .createRotation(angle: 0.4, axis: f3(1, 0, 0)) * .createTransform(0, 0, -22)
    }
    
    override func draw() {
        addPointLight(pos: f3(0, 30, 0), color: f3(1, 1, 1), intensity: 5)
        for b in boxes {
            color(b.color.x, b.color.y, b.color.z, b.color.w)
            box(b.pos.x, b.pos.y, b.pos.z, b.scale.x, b.scale.y, b.scale.z, roughness: b.roughness, metallic: b.metallic)
        }
    }
}

struct Sample11View: View {
    var body: some View {
        RayTraceSketchView(Sample11())
    }
}


