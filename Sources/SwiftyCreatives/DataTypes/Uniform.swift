//
//  Uniform.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

struct Uniform_ProjectMatrix {
    var value: f4x4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct Uniform_ViewMatrix {
    var value: f4x4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct Uniform_Color {
    var value: f4
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct Uniform_ModelPos {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct Uniform_ModelRot {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}

struct Uniform_ModelScale {
    var value: f3
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
