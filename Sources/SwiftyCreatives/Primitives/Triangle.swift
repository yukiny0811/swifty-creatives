//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public struct TriangleInfo: PrimitiveInfo {
    public final class VertexPoint {
        static let A: f3 = f3(x: 0, y: 1.0, z: 0.0)
        static let B: f3 = f3(x: cos(Float.pi * 7.0 / 6.0), y: sin(Float.pi * 7.0 / 6.0), z: 0.0)
        static let C: f3 = f3(x: cos(Float.pi * 11.0 / 6.0), y: sin(Float.pi * 11.0 / 6.0), z: 0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangle
}

public class Triangle: Primitive<TriangleInfo> {
    public required init() {
        super.init()
        bytes = [
            Vertex(position: TriangleInfo.VertexPoint.A, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: TriangleInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: TriangleInfo.VertexPoint.C, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1))
        ]
    }
}
