//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal

public protocol ProcessBase {
    init()
    func setup()
    func draw(encoder: MTLRenderCommandEncoder)
}
