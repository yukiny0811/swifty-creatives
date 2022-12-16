//
//  Box.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import Metal

public class Box: PrimitiveBase {
    static let shrinkScale: Float = 0.01
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
        static let count = 14
    }
    
    var posBuf: MTLBuffer
    var colBuf: MTLBuffer
    var mPosBuf: MTLBuffer
    var mRotBuf: MTLBuffer
    var mScaleBuf: MTLBuffer
    
    var color: f4
    var mPos: f3
    var mRot: f3
    var mScale: f3
    
    //  T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
    let positionDatas: [f3] = [
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
    ]
    
    var colorDatas: [f4] = [
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
        f4.zero,
    ]
    
    var mPosDatas: [f3] = [
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
    ]
    
    var mRotDatas: [f3] = [
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
        f3.zero,
    ]
    
    var mScaleDatas: [f3] = [
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
        f3.one,
    ]
    
    public init(pos: f3) {
        self.mPos = pos
        self.mRot = f3.zero
        self.mScale = f3.one
        self.color = f4.zero
        
        posBuf = ShaderCore.device.makeBuffer(
            bytes: positionDatas,
            length: f3.memorySize * VertexPoint.count)!
        
        colBuf = ShaderCore.device.makeBuffer(
            bytes: colorDatas,
            length: f4.memorySize * VertexPoint.count)!
        
        mPosBuf = ShaderCore.device.makeBuffer(
            bytes: mPosDatas,
            length: f3.memorySize * VertexPoint.count)!
        
        mRotBuf = ShaderCore.device.makeBuffer(
            bytes: mRotDatas,
            length: f3.memorySize * VertexPoint.count)!
        
        mScaleBuf = ShaderCore.device.makeBuffer(
            bytes: mScaleDatas,
            length: f3.memorySize * VertexPoint.count)!
        
        self.setPosition(self.mPos)
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        let simdColor = f4(r, g, b, a)
        self.color = simdColor
        colorDatas[0] = simdColor
        colorDatas[1] = simdColor
        colorDatas[2] = simdColor
        colorDatas[3] = simdColor
        colorDatas[4] = simdColor
        colorDatas[5] = simdColor
        colorDatas[6] = simdColor
        colorDatas[7] = simdColor
        colorDatas[8] = simdColor
        colorDatas[9] = simdColor
        colorDatas[10] = simdColor
        colorDatas[11] = simdColor
        colorDatas[12] = simdColor
        colorDatas[13] = simdColor
        colBuf.contents().copyMemory(from: colorDatas, byteCount: f4.memorySize * VertexPoint.count)
    }
    public func setPosition(_ p: f3) {
        self.mPos = p * Box.shrinkScale
        mPosDatas[0] = self.mPos
        mPosDatas[1] = self.mPos
        mPosDatas[2] = self.mPos
        mPosDatas[3] = self.mPos
        mPosDatas[4] = self.mPos
        mPosDatas[5] = self.mPos
        mPosDatas[6] = self.mPos
        mPosDatas[7] = self.mPos
        mPosDatas[8] = self.mPos
        mPosDatas[9] = self.mPos
        mPosDatas[10] = self.mPos
        mPosDatas[11] = self.mPos
        mPosDatas[12] = self.mPos
        mPosDatas[13] = self.mPos
        mPosBuf.contents().copyMemory(from: mPosDatas, byteCount: f3.memorySize * VertexPoint.count)
    }
    public func setScale(_ s: f3) {
        self.mScale = s
        mScaleDatas[0] = s
        mScaleDatas[1] = s
        mScaleDatas[2] = s
        mScaleDatas[3] = s
        mScaleDatas[4] = s
        mScaleDatas[5] = s
        mScaleDatas[6] = s
        mScaleDatas[7] = s
        mScaleDatas[8] = s
        mScaleDatas[9] = s
        mScaleDatas[10] = s
        mScaleDatas[11] = s
        mScaleDatas[12] = s
        mScaleDatas[13] = s
        mScaleBuf.contents().copyMemory(from: mScaleDatas, byteCount: f3.memorySize * VertexPoint.count)
    }
    public func setRotation(_ r: f3) {
        self.mRot = r
        mRotDatas[0] = r
        mRotDatas[1] = r
        mRotDatas[2] = r
        mRotDatas[3] = r
        mRotDatas[4] = r
        mRotDatas[5] = r
        mRotDatas[6] = r
        mRotDatas[7] = r
        mRotDatas[8] = r
        mRotDatas[9] = r
        mRotDatas[10] = r
        mRotDatas[11] = r
        mRotDatas[12] = r
        mRotDatas[13] = r
        mRotBuf.contents().copyMemory(from: mRotDatas, byteCount: f3.memorySize * VertexPoint.count)
    }
    public func getColor() -> f4 {
        return color
    }
    public func getScale() -> f3 {
        return mScale
    }
    public func getRotation() -> f3 {
        return mRot
    }
    public func getPosition() -> f3 {
        return mPos
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(posBuf, offset: 0, index: 0)
        encoder.setVertexBuffer(colBuf, offset: 0, index: 1)
        encoder.setVertexBuffer(mPosBuf, offset: 0, index: 2)
        encoder.setVertexBuffer(mRotBuf, offset: 0, index: 3)
        encoder.setVertexBuffer(mScaleBuf, offset: 0, index: 4)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: VertexPoint.count)
    }
}
