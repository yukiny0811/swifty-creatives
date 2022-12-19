//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public struct TriangleInfo: PrimitiveInfo {
    private final class VertexPoint {
        static let A: f3 = f3(x: 0, y: 1.0, z: 0.0)
        static let B: f3 = f3(x: cos(Float.pi * 7.0 / 6.0), y: sin(Float.pi * 7.0 / 6.0), z: 0.0)
        static let C: f3 = f3(x: cos(Float.pi * 11.0 / 6.0), y: sin(Float.pi * 11.0 / 6.0), z: 0.0)
    }
    public static let vertexCount: Int = 3
    public static let primitiveType: MTLPrimitiveType = .triangle
    public static var bytes: [f3] = [
        VertexPoint.A,
        VertexPoint.B,
        VertexPoint.C
    ]
    public static let hasTexture: [Bool] = [false]
}

public class Triangle: Primitive<TriangleInfo> {}
