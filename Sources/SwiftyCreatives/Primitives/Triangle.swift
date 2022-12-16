//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

public class Triangle {
    private final class VertexPoint {
        static let A: f3 = f3(x: 0, y: 1.0, z: 0.0)
        static let B: f3 = f3(x: cos(Float.pi * 7.0 / 6.0), y: sin(Float.pi * 7.0 / 6.0), z: 0.0)
        static let C: f3 = f3(x: cos(Float.pi * 11.0 / 6.0), y: sin(Float.pi * 11.0 / 6.0), z: 0.0)
    }
    private static let vertexCount: Int = 3
    private static let buffer: MTLBuffer = ShaderCore.device.makeBuffer(
        bytes: [
            VertexPoint.A,
            VertexPoint.B,
            VertexPoint.C
        ], length: f3.memorySize * vertexCount
    )!
    private static let primitiveType: MTLPrimitiveType = .triangle
    
    private var colBuf: MTLBuffer
    private var mPosBuf: MTLBuffer
    private var mRotBuf: MTLBuffer
    private var mScaleBuf: MTLBuffer
    
    private var _color: [f4] = [f4.zero]
    private var _mPos: [f3] = [f3.zero]
    private var _mRot: [f3] = [f3.zero]
    private var _mScale: [f3] = [f3.one]
    
    public var color: f4 { _color[0] }
    public var pos: f3 { _mPos[0] }
    public var rot: f3 { _mRot[0] }
    public var scale: f3 { _mScale[0] }
    
    private var colorNeedsUpdate = true
    private var posNeedsUpdate = true
    private var rotNeedsUpdate = true
    private var scaleNeedsUpdate = true
    
    public init() {
        colBuf = ShaderCore.device.makeBuffer(length: f4.memorySize)!
        mPosBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        mRotBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        mScaleBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
    }
    
    public func setColor(_ value: f4) {
        _color[0] = value
        colorNeedsUpdate = true
    }
    public func setPos(_ value: f3) {
        _mPos[0] = value
        posNeedsUpdate = true
    }
    public func setRot(_ value: f3) {
        _mRot[0] = value
        rotNeedsUpdate = true
    }
    public func setScale(_ value: f3) {
        _mScale[0] = value
        scaleNeedsUpdate = true
    }
    
    private func setBuffer() {
        if colorNeedsUpdate {
            colBuf.contents().copyMemory(from: _color, byteCount: f4.memorySize)
            colorNeedsUpdate = false
        }
        if posNeedsUpdate {
            mPosBuf.contents().copyMemory(from: _mPos, byteCount: f3.memorySize)
            posNeedsUpdate = false
        }
        if rotNeedsUpdate {
            mRotBuf.contents().copyMemory(from: _mRot, byteCount: f3.memorySize)
            rotNeedsUpdate = false
        }
        if scaleNeedsUpdate {
            mScaleBuf.contents().copyMemory(from: _mScale, byteCount: f3.memorySize)
            scaleNeedsUpdate = false
        }
    }

    public func draw(_ encoder: MTLRenderCommandEncoder) {
        setBuffer()
        encoder.setVertexBuffer(Self.buffer, offset: 0, index: 0)
        encoder.setVertexBuffer(colBuf, offset: 0, index: 1)
        encoder.setVertexBuffer(mPosBuf, offset: 0, index: 2)
        encoder.setVertexBuffer(mRotBuf, offset: 0, index: 3)
        encoder.setVertexBuffer(mScaleBuf, offset: 0, index: 4)
        encoder.drawPrimitives(type: Self.primitiveType, vertexStart: 0, vertexCount: Self.vertexCount)
    }
}
