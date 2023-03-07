//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd

public extension FunctionBase {
    
    func line(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes([f3(x1, y1, z1), f3(x2, y2, z2)], length: f3.memorySize * 2, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f2.zero, f2.zero], length: f2.memorySize * 2, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero], length: f3.memorySize * 2, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
    
    func line(_ pos1: f3, _ pos2: f3) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes([pos1, pos2], length: f3.memorySize * 2, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f2.zero, f2.zero], length: f2.memorySize * 2, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero], length: f3.memorySize * 2, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
}
