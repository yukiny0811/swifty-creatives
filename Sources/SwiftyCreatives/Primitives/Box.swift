//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public class SimpleBox {
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
        static let count = 14
    }
    let posBuf: MTLBuffer
    
    //  T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
    let positionDatas: [f3] = [
        VertexPoint.T,
        VertexPoint.S,
        VertexPoint.C,
        VertexPoint.B,
        VertexPoint.A,
        VertexPoint.S,
        VertexPoint.Q,
        VertexPoint.T,
        VertexPoint.R,
        VertexPoint.C,
        VertexPoint.D,
        VertexPoint.A,
        VertexPoint.R,
        VertexPoint.Q
    ]
    
    public init() {
        posBuf = ShaderCore.device.makeBuffer(
            bytes: positionDatas,
            length: f3.memorySize * VertexPoint.count)!
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(posBuf, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: VertexPoint.count)
    }
}
