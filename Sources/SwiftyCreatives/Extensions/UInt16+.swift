//
//  UInt16+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/10.
//

extension UInt16 {
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
