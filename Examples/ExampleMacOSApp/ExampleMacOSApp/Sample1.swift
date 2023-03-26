//
//  Sample1.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/02.
//

import SwiftyCreatives
import Metal

final class Sample1: Sketch {
    let bloomPP = BloomPP()
    override func draw(encoder: SCEncoder) {
        let count = 20
        for i in 0..<count {
            color(1, Float(i) / 40, 0, 0.5)
            pushMatrix()
            rotateY(Float.pi * 2 / Float(count) * Float(i))
            translate(10, 0, 0)
            box(0, 0, 0, 1, 1, 1)
            popMatrix()
        }
    }
    override func postProcess(texture: MTLTexture, commandBuffer: MTLCommandBuffer) {
        bloomPP.postProcess(commandBuffer: commandBuffer, texture: texture, threshold: 0.1, intensity: 25)
    }
}
