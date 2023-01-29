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
    
    func setColor(_ value: f4)
    func setPos(_ value: f3)
    func setRot(_ value: f3)
    func setScale(_ value: f3)
    func setMaterial(_ material: Material)
    
    func draw(_ encoder: MTLRenderCommandEncoder)
}
