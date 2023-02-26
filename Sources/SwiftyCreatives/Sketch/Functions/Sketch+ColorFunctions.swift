//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import simd

public extension Sketch {
    
    func color(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        privateEncoder?.setVertexBytes([f4(r, g, b, a)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ r: Float, _ g: Float, _ b: Float) {
        privateEncoder?.setVertexBytes([f4(r, g, b, 1)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ color: f4) {
        privateEncoder?.setVertexBytes([color], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ rgb: f3, alpha: Float) {
        privateEncoder?.setVertexBytes([f4(rgb.x, rgb.y, rgb.z, alpha)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ rgb: f3) {
        privateEncoder?.setVertexBytes([f4(rgb.x, rgb.y, rgb.z, 1)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ gray: Float) {
        privateEncoder?.setVertexBytes([f4(gray, gray, gray, 1)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func color(_ gray: Float, _ alpha: Float) {
        privateEncoder?.setVertexBytes([f4(gray, gray, gray, alpha)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
}
