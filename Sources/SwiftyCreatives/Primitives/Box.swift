//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public struct BoxInfo: PrimitiveInfo {
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    public static let vertexCount: Int = 14
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    public static let bytes: [f3] = [
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
    public static var hasTexture: [Bool] = [false]
}

public class Box: Primitive<BoxInfo> {}
