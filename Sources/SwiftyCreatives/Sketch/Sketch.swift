//
//  Sketch.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import simd

open class Sketch: SketchBase {
    
    var customMatrix: [f4x4] = [f4x4.createIdentity()]
    
    private(set) var privateEncoder: SCEncoder?
    
    public var deltaTime: Float = 0
    public var frameRate: Float { 1 / deltaTime }
    
    public var packet: SCPacket {
        SCPacket(privateEncoder: privateEncoder!, customMatrix: customMatrix)
    }
    
    public var LIGHTS: [Light] = [Light(position: f3(0, 10, 0), color: f3.one, brightness: 1, ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 50)]
    
    public init() {}
    
    // MARK: functions
    open func setupCamera(camera: some MainCameraBase) {}
    open func update(camera: some MainCameraBase) {}
    open func draw(encoder: SCEncoder) {}
    
    public func beforeDraw(encoder: SCEncoder) {
        self.customMatrix = [f4x4.createIdentity()]
        self.privateEncoder = encoder
    }
    
    open func afterDraw(texture: MTLTexture) {}
    
    public func getCustomMatrix() -> f4x4 {
        return customMatrix.reduce(f4x4.createIdentity(), *)
    }
    
    open func updateAndDrawLight(encoder: SCEncoder) {
        encoder.setFragmentBytes([LIGHTS.count], length: Int.memorySize, index: FragmentBufferIndex.LightCount.rawValue)
        encoder.setFragmentBytes(LIGHTS, length: Light.memorySize * LIGHTS.count, index: FragmentBufferIndex.Lights.rawValue)
    }
    
    #if os(macOS)
    open func mouseMoved(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseDragged(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseEntered(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseExited(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func keyDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func keyUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func viewWillStartLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    open func resize(withOldSuperviewSize oldSize: NSSize, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func viewDidEndLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    open func scrollWheel(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    #endif
    
    #if os(iOS)
    open func onScroll(delta: CGPoint, camera: some MainCameraBase, view: UIView, gestureRecognizer: UIPanGestureRecognizer) {}
    open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    #endif
}
