//
//  Numeric+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

extension Numeric {
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
