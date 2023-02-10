//
//  Vertex.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

public struct Vertex {
    public var position: f3
    public var color: f4
    public var uv: f2
    public var normal: f3
    public static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
