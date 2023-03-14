//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd

public extension FunctionBase {
    
    func boldline(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float, width: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue) // model pos
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue) // model scale
        let diffY = y2 - y1
        let diffX = x2 - x1
        if diffX <= 0.00001 {
            let corner1 = f3(x1 - width, y1, z1)
            let corner2 = f3(x1 + width, y1, z1)
            let corner3 = f3(x2 - width, y2, z2)
            let corner4 = f3(x2 + width, y2, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
        } else {
            let a_xy = diffY / diffX
            let inv_a = 1 / a_xy
            let rad = atan2(1, inv_a)
            let yValue = sin(rad) * width
            let xValue = cos(rad) * width
            let corner1 = f3(x1 - xValue, y1 + yValue, z1)
            let corner2 = f3(x1 + xValue, y1 - yValue, z1)
            let corner3 = f3(x2 - xValue, y2 + yValue, z2)
            let corner4 = f3(x2 + xValue, y2 - yValue, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
        }
        privateEncoder?.setVertexBytes([f2.zero, f2.zero, f2.zero, f2.zero], length: f2.memorySize * 4, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero, f3.zero, f3.zero], length: f3.memorySize * 4, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
    
    func boldline(_ pos1: f3, _ pos2: f3, width: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue) // model pos
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue) // model scale
        let x1 = pos1.x
        let y1 = pos1.y
        let z1 = pos1.z
        let x2 = pos2.x
        let y2 = pos2.y
        let z2 = pos2.z
        let diffY = y2 - y1
        let diffX = x2 - x1
        if diffX <= 0.00001 {
            let corner1 = f3(x1 - width, y1, z1)
            let corner2 = f3(x1 + width, y1, z1)
            let corner3 = f3(x2 - width, y2, z2)
            let corner4 = f3(x2 + width, y2, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
        } else {
            let a_xy = diffY / diffX
            let inv_a = 1 / a_xy
            let rad = atan2(1, inv_a)
            let yValue = sin(rad) * width
            let xValue = cos(rad) * width
            let corner1 = f3(x1 - xValue, y1 + yValue, z1)
            let corner2 = f3(x1 + xValue, y1 - yValue, z1)
            let corner3 = f3(x2 - xValue, y2 + yValue, z2)
            let corner4 = f3(x2 + xValue, y2 - yValue, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
        }
        privateEncoder?.setVertexBytes([f2.zero, f2.zero, f2.zero, f2.zero], length: f2.memorySize * 4, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero, f3.zero, f3.zero], length: f3.memorySize * 4, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
}
