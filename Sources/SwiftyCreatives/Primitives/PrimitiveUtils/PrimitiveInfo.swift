//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

public protocol PrimitiveInfo {
    static var vertexCount: Int { get }
    static var buffer: MTLBuffer { get }
    static var primitiveType: MTLPrimitiveType { get }
}
