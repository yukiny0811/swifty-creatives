//
//  Sample9.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import SwiftyCreatives
import SwiftUI
import Observation

@Observable
final class Sample9: Sketch {
    
    var fov: Float = 85
    
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.01)
        camera.setFov(to: fov)
    }
    
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        color(1, 0.5, 1, 0.3)
        let count = 10
        let spacing: Float = 10
        let size: Float = 1
        for z in -count...count {
            for y in -count...count {
                for x in -count...count {
                    box(Float(x) * spacing, Float(y) * spacing, Float(z) * spacing, size, size, size)
                }
            }
        }
    }
}

struct Sample9View: View {
    @State var sketch = Sample9()
    var body: some View {
        SketchView(sketch)
            .toolbar {
                ToolbarItem {
                    HStack {
                        Text("fov")
                        Slider(value: $sketch.fov, in: 10...180)
                            .frame(width: 400)
                    }
                }
            }
    }
}
