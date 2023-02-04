//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

public protocol PrimitiveBase: AnyObject {
    
    var color: f4 { get }
    var pos: f3 { get }
    var rot: f3 { get }
    var scale: f3 { get }
    
    init()
    
    func setColor(_ value: f4) -> Self
    func setPos(_ value: f3) -> Self
    func setRot(_ value: f3) -> Self
    func setScale(_ value: f3) -> Self
    func setMaterial(_ material: Material) -> Self
    
    func draw(_ encoder: MTLRenderCommandEncoder)
}
