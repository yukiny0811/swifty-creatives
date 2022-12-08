//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import Foundation

import Metal
import simd
import GLKit

public class Box {
    static let shrinkScale: Float = 0.01
    var vertexDatas: [Vertex] = []
    var buffer: MTLBuffer
    var pos: SCPoint3
    var rot: SCPoint3 = SCPoint3.zero
    var scale: SCPoint3 = SCPoint3(x: 1, y: 1, z: 1)
    var modelMatrix: simd_float4x4 = simd_float4x4(0)
    public init(pos: SCPoint3) {
        let color = SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
        self.pos = pos
        
        var tempModelMatrix = GLKMatrix4Identity
        tempModelMatrix = GLKMatrix4Translate(tempModelMatrix, pos.shrink(Box.shrinkScale).x, pos.shrink(Box.shrinkScale).y, pos.shrink(Box.shrinkScale).z)
        tempModelMatrix = GLKMatrix4RotateX(tempModelMatrix, rot.x)
        tempModelMatrix = GLKMatrix4RotateY(tempModelMatrix, rot.y)
        tempModelMatrix = GLKMatrix4RotateZ(tempModelMatrix, rot.z)
        tempModelMatrix = GLKMatrix4Scale(tempModelMatrix, scale.x, scale.y, scale.z)
        modelMatrix = tempModelMatrix.toSimd()
        
        let model1 = modelMatrix.columns.0
        let model2 = modelMatrix.columns.1
        let model3 = modelMatrix.columns.2
        let model4 = modelMatrix.columns.3
        
        let A = Vertex(position: SCPoint3(x: -1.0, y:   1.0, z:   1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let B = Vertex(position: SCPoint3(x: -1.0, y:  -1.0, z:   1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let C = Vertex(position: SCPoint3(x:  1.0, y:  -1.0, z:   1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let D = Vertex(position: SCPoint3(x:  1.0, y:   1.0, z:   1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let Q = Vertex(position: SCPoint3(x: -1.0, y:   1.0, z:  -1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let R = Vertex(position: SCPoint3(x:  1.0, y:   1.0, z:  -1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let S = Vertex(position: SCPoint3(x: -1.0, y:  -1.0, z:  -1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        let T = Vertex(position: SCPoint3(x:  1.0, y:  -1.0, z:  -1.0).simd, color: color, modelMatrix1: model1, modelMatrix2: model2, modelMatrix3: model3, modelMatrix4: model4)
        
        vertexDatas = [
//            A,B,C ,A,C,D,   //Front
//            R,T,S ,Q,R,S,   //Back
//            Q,S,B ,Q,B,A,   //Left
//            D,C,T ,D,T,R,   //Right
//            Q,A,D ,Q,D,R,   //Top
//            B,S,T ,B,T,C    //Bot
            T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
        ]
        //1 Q
        //2 R
        //3 S
        //4 T
        //5 A
        //6 D
        //7 C
        //8 B
        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
    }
    func setModelMatrix() {
        var tempModelMatrix = GLKMatrix4Identity
        tempModelMatrix = GLKMatrix4Translate(tempModelMatrix, pos.shrink(Box.shrinkScale).x, pos.shrink(Box.shrinkScale).y, pos.shrink(Box.shrinkScale).z)
        tempModelMatrix = GLKMatrix4RotateX(tempModelMatrix, rot.x)
        tempModelMatrix = GLKMatrix4RotateY(tempModelMatrix, rot.y)
        tempModelMatrix = GLKMatrix4RotateZ(tempModelMatrix, rot.z)
        tempModelMatrix = GLKMatrix4Scale(tempModelMatrix, scale.x, scale.y, scale.z)
        modelMatrix = tempModelMatrix.toSimd()
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        for i in 0..<vertexDatas.count {
            vertexDatas[i].color = simd_float4(r, g, b, a)
        }
        updateBuffer()
    }
    public func setScale(_ s: SCPoint3) {
        self.scale = s
        setModelMatrix()
        updateBuffer()
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexDatas.count)
    }
    func updateBuffer() {
        for i in 0..<vertexDatas.count {
            let model1 = modelMatrix.columns.0
            let model2 = modelMatrix.columns.1
            let model3 = modelMatrix.columns.2
            let model4 = modelMatrix.columns.3
            vertexDatas[i].modelMatrix1 = model1
            vertexDatas[i].modelMatrix2 = model2
            vertexDatas[i].modelMatrix3 = model3
            vertexDatas[i].modelMatrix4 = model4
        }
        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
    }
}
