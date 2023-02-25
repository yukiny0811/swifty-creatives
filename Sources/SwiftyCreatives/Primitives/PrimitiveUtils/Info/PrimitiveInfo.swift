//
//  PrimitiveInfo.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

public protocol PrimitiveInfo {
    static var primitiveType: MTLPrimitiveType { get }
    static var vertices: [f3] { get }
    static var uvs: [f2] { get }
    static var normals: [f3] { get }
}
