//
//  Img.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit

open class Img: Primitive<RectShapeInfo>, ImageLoadable {
    public override init() { super.init() }
    public var texture: MTLTexture?
    
    @available(*, unavailable, message: "Use img() in Sketch instead.")
    override public func draw(_ encoder: SCEncoder) {}
}
