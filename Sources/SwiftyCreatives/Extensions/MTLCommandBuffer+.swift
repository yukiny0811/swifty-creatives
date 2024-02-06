//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import Metal

public extension MTLCommandBuffer {
    func compute(_ f: @escaping (MTLComputeCommandEncoder) -> ()) {
        let encoder = self.makeComputeCommandEncoder()!
        f(encoder)
        encoder.endEncoding()
    }
}
