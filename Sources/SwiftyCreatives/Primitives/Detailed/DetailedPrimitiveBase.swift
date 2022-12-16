//
//  PrimitiveBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

import Metal

protocol PrimitiveBase {
    static var shrinkScale: Float { get }
    
    var posBuf: MTLBuffer { get set }
    var colBuf: MTLBuffer { get set }
    var mPosBuf: MTLBuffer { get set }
    var mRotBuf: MTLBuffer { get set }
    var mScaleBuf: MTLBuffer { get set }

    var color: f4 { get set }
    var mPos: f3 { get set }
    var mRot: f3 { get set }
    var mScale: f3 { get set }
    
    var positionDatas: [f3] { get }
    var colorDatas: [f4] { get set }
    var mPosDatas: [f3] { get set }
    var mRotDatas: [f3] { get set }
    var mScaleDatas: [f3] { get set }
    
    func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float)
    func setPosition(_ p: f3)
    func setScale(_ s: f3)
    func setRotation(_ r: f3)
    
    func getColor() -> f4
    func getScale() -> f3
    func getRotation() -> f3
    func getPosition() -> f3
    
    func draw(_ encoder: MTLRenderCommandEncoder)
}
