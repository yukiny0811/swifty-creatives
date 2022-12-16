//
//  SimpleUniform.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

//var viewMatrix: f4x4
//var color: f4
//var modelPos: f3
//var modelRot: f3
//var modelScale: f3

struct SimpleUniform_ProjectMatrix {
    var value: f4x4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct SimpleUniform_ViewMatrix {
    var value: f4x4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct SimpleUniform_Color {
    var value: f4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct SimpleUniform_ModelPos {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct SimpleUniform_ModelRot {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct SimpleUniform_ModelScale {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
