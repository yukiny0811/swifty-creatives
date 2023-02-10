//
//  Int+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/10.
//

extension Int {
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
