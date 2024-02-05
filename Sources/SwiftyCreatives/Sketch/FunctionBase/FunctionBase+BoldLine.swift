//
//  FunctionBase+BoldLine.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func boldline(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float, width: Float) {
        let diffY = abs(y2 - y1)
        let diffX = abs(x2 - x1)
        if diffX <= 0.00001 {
            let corner1 = f3(x1 - width, y1, z1)
            let corner2 = f3(x1 + width, y1, z1)
            let corner3 = f3(x2 - width, y2, z2)
            let corner4 = f3(x2 + width, y2, z2)
            setVertices([corner1, corner2, corner3, corner4])
        } else if diffY <= 0.00001 {
            let corner1 = f3(x1, y1 - width, z1)
            let corner2 = f3(x1, y1 + width, z1)
            let corner3 = f3(x2, y2 - width, z2)
            let corner4 = f3(x2, y2 + width, z2)
            setVertices([corner1, corner2, corner3, corner4])
        } else {
            let a_xy = (y2 - y1) / (x2 - x1)
            let inv_a = 1 / a_xy
            let rad = atan2(1, inv_a)
            let yValue = sin(rad) * width
            let xValue = cos(rad) * width
            let corner1 = f3(x1 - yValue, y1 + xValue, z1)
            let corner2 = f3(x1 + yValue, y1 - xValue, z1)
            let corner3 = f3(x2 - yValue, y2 + xValue, z2)
            let corner4 = f3(x2 + yValue, y2 - xValue, z2)
            setVertices([corner1, corner2, corner3, corner4])
        }
        setUVs([f2.zero, f2.zero, f2.zero, f2.zero])
        setNormals([f3.zero, f3.zero, f3.zero, f3.zero])
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        privateEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
    
    func boldline(_ pos1: f3, _ pos2: f3, width: Float) {
        boldline(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, width: width)
    }
}
