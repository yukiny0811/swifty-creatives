//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public class Box {
    final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    public static let vertexCount: Int = 14
    public static let buffer: MTLBuffer = ShaderCore.device.makeBuffer(
        bytes: [
            VertexPoint.T,
            VertexPoint.S,
            VertexPoint.C,
            VertexPoint.B,
            VertexPoint.A,
            VertexPoint.S,
            VertexPoint.Q,
            VertexPoint.T,
            VertexPoint.R,
            VertexPoint.C,
            VertexPoint.D,
            VertexPoint.A,
            VertexPoint.R,
            VertexPoint.Q
        ], length: f3.memorySize * vertexCount
    )!
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    
    public var colBuf: MTLBuffer
    public var mPosBuf: MTLBuffer
    public var mRotBuf: MTLBuffer
    public var mScaleBuf: MTLBuffer
    public init() {
        self.colBuf = ShaderCore.device.makeBuffer(length: f4.memorySize)!
        self.mPosBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        self.mRotBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        self.mScaleBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
    }
    public func draw(_ encoder: MTLRenderCommandEncoder, _ pass: BufferPass) {
        self.colBuf.contents().copyMemory(from: pass.colBuf.contents(), byteCount: f4.memorySize)
        self.mPosBuf = pass.mPosBuf
        self.mRotBuf = pass.mRotBuf
        self.mScaleBuf = pass.mScaleBuf
        encoder.setVertexBuffer(Self.buffer, offset: 0, index: 0)
        encoder.setVertexBuffer(colBuf, offset: 0, index: 1)
        encoder.setVertexBuffer(mPosBuf, offset: 0, index: 2)
        encoder.setVertexBuffer(mRotBuf, offset: 0, index: 3)
        encoder.setVertexBuffer(mScaleBuf, offset: 0, index: 4)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: Self.vertexCount)
    }
}
