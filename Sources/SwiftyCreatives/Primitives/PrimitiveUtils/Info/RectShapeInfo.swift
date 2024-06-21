//
//  RectShapeInfo.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import Metal

public struct RectShapeInfo: PrimitiveInfo {
    public static var vertices: [f3] = [
        Self.VertexPoint.A,
        Self.VertexPoint.B,
        Self.VertexPoint.D,
        Self.VertexPoint.C
    ]
    
    public static var uvs: [f2] = [
        f2(0, 0),
        f2(0, 1),
        f2(1, 0),
        f2(1, 1)
    ]
    
    public static var normals: [f3] = [
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1)
    ]
    
    public final class VertexPoint {
        public static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        public static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        public static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        public static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}
