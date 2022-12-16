//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public class BufferPass {
    public var colBuf: MTLBuffer
    public var mPosBuf: MTLBuffer
    public var mRotBuf: MTLBuffer
    public var mScaleBuf: MTLBuffer
    public var projectionBuf: MTLBuffer
    public var viewBuf: MTLBuffer
    public init(
        colBuf: MTLBuffer,
        mPosBuf: MTLBuffer,
        mRotBuf: MTLBuffer,
        mScaleBuf: MTLBuffer,
        projectionBuf: MTLBuffer,
        viewBuf: MTLBuffer
    ) {
        self.colBuf = colBuf
        self.mPosBuf = mPosBuf
        self.mRotBuf = mRotBuf
        self.mScaleBuf = mScaleBuf
        self.projectionBuf = projectionBuf
        self.viewBuf = viewBuf
    }
}

open class Sketch: SketchBase {
    
    public var colorUpdated = true
    public var mPosUpdated = true
    public var mRotUpdated = true
    public var mScaleUpdated = true
    
    public var pass: BufferPass
    
    required public init(pass: BufferPass) {
        self.pass = pass
    }
    
    open var color: [f4] = [f4.zero]
    open var mPos: [f3] = [f3.zero]
    open var mRot: [f3] = [f3.zero]
    open var mScale: [f3] = [f3.one]
    
    open func setup() {}
    open func update() {}
    open func draw(encoder: MTLRenderCommandEncoder) {
        func test() {
            
        }
    }
    
    open func cameraProcess(camera: MainCamera<some CameraConfigBase>) {}
    
    #if os(macOS)
    open func mouseDown(with event: NSEvent) {}
    open func mouseDragged(with event: NSEvent) {}
    open func mouseUp(with event: NSEvent) {}
    open func mouseEntered(with event: NSEvent) {}
    open func mouseExited(with event: NSEvent) {}
    open func keyDown(with event: NSEvent) {}
    open func keyUp(with event: NSEvent) {}
    open func viewWillStartLiveResize() {}
    open func resize(withOldSuperviewSize oldSize: NSSize) {}
    open func viewDidEndLiveResize() {}
    #endif
    
    #if os(iOS)
    open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    #endif
}
