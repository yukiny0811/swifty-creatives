//
//  SketchBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public protocol SketchBase: AnyObject {
    
    // MARK: variables
    var pass: BufferPass { get set }
    
    var colorUpdated: Bool { get set }
    var mPosUpdated: Bool { get set }
    var mRotUpdated: Bool { get set }
    var mScaleUpdated: Bool { get set }
    
    var color: [f4] { get set }
    var mPos: [f3] { get set }
    var mRot: [f3] { get set }
    var mScale: [f3] { get set }
    
    // MARK: initializer
    init(pass: BufferPass)
    
    // MARK: functions
    func setup()
    func update()
    func draw(encoder: MTLRenderCommandEncoder)
    
    func cameraProcess(camera: MainCamera<some CameraConfigBase>)
    
    #if os(macOS)
    func mouseDown(with event: NSEvent)
    func mouseDragged(with event: NSEvent)
    func mouseUp(with event: NSEvent)
    func mouseEntered(with event: NSEvent)
    func mouseExited(with event: NSEvent)
    func keyDown(with event: NSEvent)
    func keyUp(with event: NSEvent)
    func viewWillStartLiveResize()
    func resize(withOldSuperviewSize oldSize: NSSize)
    func viewDidEndLiveResize()
    #endif

    #if os(iOS)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    #endif
}


// draw control functions
public extension SketchBase {
    func setColor(_ value: f4) {
        self.color[0] = value
        self.colorUpdated = true
    }
    func setPos(_ value: f3) {
        self.mPos[0] = value
        self.mPosUpdated = true
    }
    func setRot(_ value: f3) {
        self.mRot[0] = value
        self.mRotUpdated = true
    }
    func setScale(_ value: f3) {
        self.mScale[0] = value
        self.mScaleUpdated = true
    }
}

// draw functions
public extension SketchBase {
    func drawBox(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(Box.buffer, offset: 0, index: 0)
        updateCheck(encoder: encoder)
        encoder.drawPrimitives(type: Box.primitiveType, vertexStart: 0, vertexCount: Box.vertexCount)
    }
    
    private func updateCheck(encoder: MTLRenderCommandEncoder) {
        if self.colorUpdated {
            self.pass.colBuf.contents().copyMemory(from: self.color, byteCount: f4.memorySize)
            encoder.setVertexBuffer(self.pass.colBuf, offset: 0, index: 1)
            self.colorUpdated = false
        }
        if self.mPosUpdated {
            self.pass.mPosBuf.contents().copyMemory(from: self.mPos, byteCount: f3.memorySize)
            encoder.setVertexBuffer(self.pass.mPosBuf, offset: 0, index: 2)
            self.mPosUpdated = false
        }
        if self.mRotUpdated {
            self.pass.mRotBuf.contents().copyMemory(from: self.mRot, byteCount: f3.memorySize)
            encoder.setVertexBuffer(self.pass.mRotBuf, offset: 0, index: 3)
            self.mRotUpdated = false
        }
        if self.mScaleUpdated {
            self.pass.mScaleBuf.contents().copyMemory(from: self.mScale, byteCount: f3.memorySize)
            encoder.setVertexBuffer(self.pass.mScaleBuf, offset: 0, index: 4)
            self.mScaleUpdated = false
        }
    }
}
