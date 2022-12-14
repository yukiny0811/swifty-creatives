//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import Foundation

import Metal
import simd
import GLKit

public class NewBox {
    private static let shrinkScale: Float = 0.01
    private final class VertexPoint {
        static let A: simd_float3 = simd_float3(x: -1.0, y:   1.0, z:   1.0)
        static let B: simd_float3 = simd_float3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: simd_float3 = simd_float3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: simd_float3 = simd_float3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: simd_float3 = simd_float3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: simd_float3 = simd_float3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: simd_float3 = simd_float3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: simd_float3 = simd_float3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    private var vertexDatas: [Vertex] = []
    
    private var posBuf: MTLBuffer
    private var colBuf: MTLBuffer
    private var mPosBuf: MTLBuffer
    private var mRotBuf: MTLBuffer
    private var mScaleBuf: MTLBuffer
    
    private var pos: simd_float3
    private var rot: simd_float3
    private var scale: simd_float3
    public init(pos: simd_float3) {
        self.pos = pos
        self.rot = simd_float3.zero
        self.scale = simd_float3.one
        let modelPos = self.pos * NewBox.shrinkScale
        
        //  T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
        vertexDatas = [
            Vertex(position: VertexPoint.T, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.B, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.T, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.D, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
        ]
        
        posBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.position
            },
            length: MemoryLayout<simd_float3>.stride * vertexDatas.count)!
        colBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.color
            },
            length: MemoryLayout<simd_float4>.stride * vertexDatas.count)!
        mPosBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelPos
            },
            length: MemoryLayout<simd_float3>.stride * vertexDatas.count)!
        mRotBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelRot
            },
            length: MemoryLayout<simd_float3>.stride * vertexDatas.count)!
        mScaleBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelScale
            },
            length: MemoryLayout<simd_float3>.stride * vertexDatas.count)!
        updateBuffer()
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        let simdColor = simd_float4(r, g, b, a)
        for i in 0..<vertexDatas.count {
            vertexDatas[i].color = simdColor
        }
        updateBuffer()
    }
    public func setPosition(_ p: simd_float3) {
        self.pos = p * NewBox.shrinkScale
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelPos = self.pos
        }
        updateBuffer()
    }
    public func setScale(_ s: simd_float3) {
        self.scale = s
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelScale = self.scale
        }
        updateBuffer()
    }
    public func setRotation(_ r: simd_float3) {
        self.rot = r
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelRot = self.rot
        }
        updateBuffer()
    }
    public func getScale() -> simd_float3 {
        return scale
    }
    public func getRotation() -> simd_float3 {
        return rot
    }
    public func getPosition() -> simd_float3 {
        return pos
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(posBuf, offset: 0, index: 0)
        encoder.setVertexBuffer(colBuf, offset: 0, index: 1)
        encoder.setVertexBuffer(mPosBuf, offset: 0, index: 2)
        encoder.setVertexBuffer(mRotBuf, offset: 0, index: 3)
        encoder.setVertexBuffer(mScaleBuf, offset: 0, index: 4)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexDatas.count)
    }
    private func updateBuffer() {
        colBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.color
            },
            byteCount: MemoryLayout<simd_float4>.stride * vertexDatas.count)
        mPosBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelPos
            },
            byteCount: MemoryLayout<simd_float3>.stride * vertexDatas.count)
        mRotBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelRot
            },
            byteCount: MemoryLayout<simd_float3>.stride * vertexDatas.count)
        mScaleBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelScale
            },
            byteCount: MemoryLayout<simd_float3>.stride * vertexDatas.count)
    }
}
