//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import Metal

public struct ModelObjectInfo: PrimitiveInfo {
    public static var vertices: [f3] = []
    public static var uvs: [f2] = []
    public static var normals: [f3] = []
    public static let vertexCount: Int = 0
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    public static let hasTexture: [Bool] = [true]
}
