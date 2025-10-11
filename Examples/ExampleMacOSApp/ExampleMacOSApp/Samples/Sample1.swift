//
//  Sample1.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives
import SwiftUI

final class Sample1: Sketch {
    
    let bloomPostProcessor = BloomPostProcessor()
    
    override func draw(encoder: SCEncoder, camera: MainCamera) {
        let count = 20
        for i in 0..<count {
            color(1, Float(i) / 40, 0, 0.5)
            push {
                rotateY(Float.pi * 2 / Float(count) * Float(i))
                translate(10, 0, 0)
                box(0, 0, 0, 1, 1, 1)
            }
        }
    }
    
    override func postProcess(texture: MTLTexture, commandBuffer: MTLCommandBuffer) {
        bloomPostProcessor.dispatch(texture: texture, threshold: 0.1, intensity: 25, commandBuffer: commandBuffer)
    }
}

struct Sample1View: View {
    var body: some View {
        SketchView(Sample1())
    }
}
