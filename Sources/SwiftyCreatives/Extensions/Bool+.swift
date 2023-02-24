//
//  Bool+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/10.
//

extension Bool {
    @usableFromInline
    static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
