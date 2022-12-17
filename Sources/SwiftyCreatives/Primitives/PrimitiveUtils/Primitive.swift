//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

open class Primitive<Info: PrimitiveInfo>: PrimitiveBase {
    
    private var colBuf: MTLBuffer
    private var mPosBuf: MTLBuffer
    private var mRotBuf: MTLBuffer
    private var mScaleBuf: MTLBuffer
    
    private var colorPointer: UnsafeMutablePointer<f4>
    private var posPointer: UnsafeMutablePointer<f3>
    private var rotPointer: UnsafeMutablePointer<f3>
    private var scalePointer: UnsafeMutablePointer<f3>
    
    private var _color: f4 = f4.zero
    private var _mPos: f3 = f3.zero
    private var _mRot: f3 = f3.zero
    private var _mScale: f3 = f3.one
    
    public var color: f4 { _color }
    public var pos: f3 { _mPos }
    public var rot: f3 { _mRot }
    public var scale: f3 { _mScale }
    
    private var colorNeedsUpdate = true
    private var posNeedsUpdate = true
    private var rotNeedsUpdate = true
    private var scaleNeedsUpdate = true
    
    required public init() {
        colBuf = ShaderCore.device.makeBuffer(length: f4.memorySize)!
        mPosBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        mRotBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        mScaleBuf = ShaderCore.device.makeBuffer(length: f3.memorySize)!
        
        colorPointer = colBuf.contents().bindMemory(to: f4.self, capacity: 1)
        posPointer = mPosBuf.contents().bindMemory(to: f3.self, capacity: 1)
        rotPointer = mRotBuf.contents().bindMemory(to: f3.self, capacity: 1)
        scalePointer = mScaleBuf.contents().bindMemory(to: f3.self, capacity: 1)
    }
    
    public func setColor(_ value: f4) {
        _color = value
        colorNeedsUpdate = true
    }
    
    public func setPos(_ value: f3) {
        _mPos = value
        posNeedsUpdate = true
    }
    
    public func setRot(_ value: f3) {
        _mRot = value
        rotNeedsUpdate = true
    }
    
    public func setScale(_ value: f3) {
        _mScale = value
        scaleNeedsUpdate = true
    }
    
    private func setBuffer(encoder: MTLRenderCommandEncoder) {
        if colorNeedsUpdate {
            colorPointer.pointee = color
            colorNeedsUpdate = false
        }
        if posNeedsUpdate {
            posPointer.pointee = pos
            posNeedsUpdate = false
        }
        if rotNeedsUpdate {
            rotPointer.pointee = rot
            rotNeedsUpdate = false
        }
        if scaleNeedsUpdate {
            scalePointer.pointee = scale
            scaleNeedsUpdate = false
        }
    }
    
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        setBuffer(encoder: encoder)
        encoder.setVertexBuffer(Info.buffer, offset: 0, index: 0)
        encoder.setVertexBuffer(colBuf, offset: 0, index: 1)
        encoder.setVertexBuffer(mPosBuf, offset: 0, index: 2)
        encoder.setVertexBuffer(mRotBuf, offset: 0, index: 3)
        encoder.setVertexBuffer(mScaleBuf, offset: 0, index: 4)
        encoder.drawPrimitives(type: Info.primitiveType, vertexStart: 0, vertexCount: Info.vertexCount)
    }
}
