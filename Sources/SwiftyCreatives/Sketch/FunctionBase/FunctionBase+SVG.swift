//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import SimpleSimdSwift
import SVGVertexBuilder
import Metal

public extension FunctionBase {
    
    func svg(_ object: SVGObj, colors: [f4], primitiveType: MTLPrimitiveType = .triangle) {
        for (i, path) in object.triangulated.enumerated() {
            let index = min(i, colors.count-1)
            color(colors[index])
            if path.count * f3.memorySize < 4096 {
                mesh(path, primitiveType: primitiveType)
            } else {
                if let buffer = ShaderCore.device.makeBuffer(bytes: path, length: path.count * f3.memorySize) {
                    mesh(buffer, count: path.count)
                }
            }
        }
    }
}
