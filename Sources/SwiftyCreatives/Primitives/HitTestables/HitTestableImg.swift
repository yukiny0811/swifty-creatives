//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/25.
//

import MetalKit

open class HitTestableImg: RectanglePlanePrimitive<RectShapeInfo>, ImageLoadable {
    public override init() { super.init() }
    public var texture: MTLTexture?
    
    @available(*, unavailable, message: "Use img() in Sketch instead.")
    override public func draw(_ encoder: SCEncoder) {}
    
    @available(*, unavailable, message: "Use img() in Sketch instead.")
    public override func drawWithCache(packet: SCPacket) {}
    
    @available(*, unavailable, message: "Use img() in Sketch instead.")
    public override func drawWithCache(encoder: SCEncoder, customMatrix: f4x4) {}
}
