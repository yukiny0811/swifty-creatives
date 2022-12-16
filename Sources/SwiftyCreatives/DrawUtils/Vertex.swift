//
//  SimpleVertex.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

struct Vertex {
    var position: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
