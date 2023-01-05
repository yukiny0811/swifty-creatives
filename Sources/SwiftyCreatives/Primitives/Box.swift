//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public struct BoxInfo: PrimitiveInfo {
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangle
}

public class Box: Primitive<BoxInfo> {
    
    public required init() {
        super.init()
        bytes = [
            Vertex(position: BoxInfo.VertexPoint.A, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: BoxInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: BoxInfo.VertexPoint.C, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: BoxInfo.VertexPoint.A, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: BoxInfo.VertexPoint.C, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            Vertex(position: BoxInfo.VertexPoint.D, color: f4.zero, uv: f2.zero, normal: f3(0, 0, 1)),
            
            Vertex(position: BoxInfo.VertexPoint.R, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            Vertex(position: BoxInfo.VertexPoint.T, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            Vertex(position: BoxInfo.VertexPoint.S, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            Vertex(position: BoxInfo.VertexPoint.Q, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            Vertex(position: BoxInfo.VertexPoint.R, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            Vertex(position: BoxInfo.VertexPoint.S, color: f4.zero, uv: f2.zero, normal: f3(0, 0, -1)),
            
            Vertex(position: BoxInfo.VertexPoint.Q, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.S, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.Q, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.A, color: f4.zero, uv: f2.zero, normal: f3(-1, 0, 0)),
            
            Vertex(position: BoxInfo.VertexPoint.D, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.C, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.T, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.D, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.T, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            Vertex(position: BoxInfo.VertexPoint.R, color: f4.zero, uv: f2.zero, normal: f3(1, 0, 0)),
            
            Vertex(position: BoxInfo.VertexPoint.Q, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            Vertex(position: BoxInfo.VertexPoint.A, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            Vertex(position: BoxInfo.VertexPoint.D, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            Vertex(position: BoxInfo.VertexPoint.Q, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            Vertex(position: BoxInfo.VertexPoint.D, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            Vertex(position: BoxInfo.VertexPoint.R, color: f4.zero, uv: f2.zero, normal: f3(0, 1, 0)),
            
            Vertex(position: BoxInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0)),
            Vertex(position: BoxInfo.VertexPoint.S, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0)),
            Vertex(position: BoxInfo.VertexPoint.T, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0)),
            Vertex(position: BoxInfo.VertexPoint.B, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0)),
            Vertex(position: BoxInfo.VertexPoint.T, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0)),
            Vertex(position: BoxInfo.VertexPoint.C, color: f4.zero, uv: f2.zero, normal: f3(0, -1, 0))
        ]
    }
}
