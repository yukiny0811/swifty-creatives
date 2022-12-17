//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public struct RectInfo: PrimitiveInfo {
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let vertexCount: Int = 4
    public static let buffer: MTLBuffer = ShaderCore.device.makeBuffer(
        bytes: [
            VertexPoint.A,
            VertexPoint.B,
            VertexPoint.D,
            VertexPoint.C
        ], length: f3.memorySize * vertexCount
    )!
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}

public class Rect: Primitive<RectInfo> {}
