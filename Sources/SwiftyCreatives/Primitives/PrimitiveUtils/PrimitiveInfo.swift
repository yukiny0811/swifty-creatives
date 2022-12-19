//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

public protocol PrimitiveInfo {
    static var vertexCount: Int { get }
    static var primitiveType: MTLPrimitiveType { get }
    static var bytes: [f3] { get }
    static var hasTexture: [Bool] { get }
}
