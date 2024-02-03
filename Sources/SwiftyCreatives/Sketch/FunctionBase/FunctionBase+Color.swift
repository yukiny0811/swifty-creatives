//
//  FunctionBase+Color.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func color(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        setColor(.init(r, g, b, a))
    }
    
    func color(_ r: Float, _ g: Float, _ b: Float) {
        setColor(.init(r, g, b, 1))
    }
    
    func color(_ color: f4) {
        setColor(color)
    }
    
    func color(_ rgb: f3, alpha: Float) {
        setColor(f4(rgb.x, rgb.y, rgb.z, alpha))
    }
    
    func color(_ rgb: f3) {
        setColor(f4(rgb.x, rgb.y, rgb.z, 1))
    }
    
    func color(_ gray: Float) {
        setColor(f4(gray, gray, gray, 1))
    }
    
    func color(_ gray: Float, _ alpha: Float) {
        setColor(f4(gray, gray, gray, alpha))
    }
}
