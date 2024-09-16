//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import SimpleSimdSwift
import SVGVertexBuilder
import Metal

public extension HasSketchFunctions {

    @DrawFunction
    static func svg(_ encoder: MTLRenderCommandEncoder?, _ object: SVGObj, colors: [f4], primitiveType: MTLPrimitiveType = .triangle) {
        for (i, path) in object.triangulated.enumerated() {
            let index = min(i, colors.count-1)
            Self.color(encoder, colors[index])
            if path.count * f3.memorySize < 4096 {
                Self.mesh(encoder, path, primitiveType: primitiveType)
            } else {
                if let buffer = ShaderCore.device.makeBuffer(bytes: path, length: path.count * f3.memorySize) {
                    Self.mesh(encoder, buffer)
                }
            }
        }
    }

    @DrawFunction
    static func svg(_ encoder: MTLRenderCommandEncoder?, _ object: SVGObj, primitiveType: MTLPrimitiveType = .triangle) {
        for (i, path) in object.triangulated.enumerated() {
            Self.color(encoder, object.colors[i])
            if path.count * f3.memorySize < 4096 {
                Self.mesh(encoder, path, primitiveType: primitiveType)
            } else {
                if let buffer = ShaderCore.device.makeBuffer(bytes: path, length: path.count * f3.memorySize) {
                    Self.mesh(encoder, buffer)
                }
            }
        }
    }
}
