//
//  Vertex.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

struct Vertex {
    var position: f3
    var color: f4
    var modelPos: f3
    var modelRot: f3
    var modelScale: f3
    static var memorySize: Int {
        return MemoryLayout<Vertex>.stride
    }
}
