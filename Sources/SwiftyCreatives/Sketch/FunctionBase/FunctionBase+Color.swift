//
//  FunctionBase+Color.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension HasSketchFunctions {

    @DrawFunction
    func color(_ encoder: MTLRenderCommandEncoder?, _ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        Self.setColor(encoder, .init(r, g, b, a))
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ r: Float, _ g: Float, _ b: Float) {
        Self.setColor(encoder, .init(r, g, b, 1))
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ color: f4) {
        Self.setColor(encoder, color)
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ rgb: f3, alpha: Float) {
        Self.setColor(encoder, f4(rgb.x, rgb.y, rgb.z, alpha))
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ rgb: f3) {
        Self.setColor(encoder, f4(rgb.x, rgb.y, rgb.z, 1))
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ gray: Float) {
        Self.setColor(encoder, f4(gray, gray, gray, 1))
    }
    
    @DrawFunction
    static func color(_ encoder: MTLRenderCommandEncoder?, _ gray: Float, _ alpha: Float) {
        Self.setColor(encoder, f4(gray, gray, gray, alpha))
    }
}
