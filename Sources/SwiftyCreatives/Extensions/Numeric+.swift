//
//  Numeric+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

extension Numeric {
    public static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
