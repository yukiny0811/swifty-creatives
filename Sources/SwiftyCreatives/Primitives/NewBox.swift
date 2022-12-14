//
//  NewBox.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import Metal

public class NewBox {
    private static let shrinkScale: Float = 0.01
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    private var vertexDatas: [Vertex] = []
    
    private var posBuf: MTLBuffer
    private var colBuf: MTLBuffer
    private var mPosBuf: MTLBuffer
    private var mRotBuf: MTLBuffer
    private var mScaleBuf: MTLBuffer
    
    private var pos: f3
    private var rot: f3
    private var scale: f3
    public init(pos: f3) {
        self.pos = pos
        self.rot = f3.zero
        self.scale = f3.one
        let modelPos = self.pos * NewBox.shrinkScale
        
        //  T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
        vertexDatas = [
            Vertex(position: VertexPoint.T, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.B, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.T, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.D, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
        ]
        
        posBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.position
            },
            length: f3.memorySize * vertexDatas.count)!
        colBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.color
            },
            length: f4.memorySize * vertexDatas.count)!
        mPosBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelPos
            },
            length: f3.memorySize * vertexDatas.count)!
        mRotBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelRot
            },
            length: f3.memorySize * vertexDatas.count)!
        mScaleBuf = ShaderCore.device.makeBuffer(
            bytes: vertexDatas.map { v in
                v.modelScale
            },
            length: f3.memorySize * vertexDatas.count)!
        updateBuffer()
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        let simdColor = f4(r, g, b, a)
        for i in 0..<vertexDatas.count {
            vertexDatas[i].color = simdColor
        }
        updateBuffer()
    }
    public func setPosition(_ p: f3) {
        self.pos = p * NewBox.shrinkScale
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelPos = self.pos
        }
        updateBuffer()
    }
    public func setScale(_ s: f3) {
        self.scale = s
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelScale = self.scale
        }
        updateBuffer()
    }
    public func setRotation(_ r: f3) {
        self.rot = r
        for i in 0..<vertexDatas.count {
            vertexDatas[i].modelRot = self.rot
        }
        updateBuffer()
    }
    public func getScale() -> f3 {
        return scale
    }
    public func getRotation() -> f3 {
        return rot
    }
    public func getPosition() -> f3 {
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
            byteCount: f4.memorySize * vertexDatas.count)
        mPosBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelPos
            },
            byteCount: f3.memorySize * vertexDatas.count)
        mRotBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelRot
            },
            byteCount: f3.memorySize * vertexDatas.count)
        mScaleBuf.contents().copyMemory(
            from: vertexDatas.map { v in
                v.modelScale
            },
            byteCount: f3.memorySize * vertexDatas.count)
    }
}
