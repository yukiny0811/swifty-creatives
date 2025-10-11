//
//  Sample4.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives
import SwiftUI

@SketchObject
class MyBox {
    var pos: f3
    var col: f4
    var scale: f3
    init(pos: f3, col: f4, scale: f3) {
        self.pos = pos
        self.col = col
        self.scale = scale
    }
    func draw() {
        color(col)
        box(pos, scale)
    }
}

final class Sample4: Sketch {
    var objects: [MyBox] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = MyBox(
                pos: f3.randomPoint(-7...7),
                col: f4.randomPoint(0...1),
                scale: f3.randomPoint(1...2)
            )
            objects.append(box)
        }
    }
    override func update(camera: MainCamera) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        for o in objects {
            o.draw(encoder: encoder, customMatrix: getCustomMatrix())
        }
    }
}

struct Sample4View: View {
    var body: some View {
        SketchView(Sample4())
    }
}

