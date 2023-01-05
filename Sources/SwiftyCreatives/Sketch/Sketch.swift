//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

import Metal

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

open class Sketch: SketchBase {
    
    public var LIGHTS: [Light] = [Light(position: f3(0, 10, 0), color: f3.one, brightness: 1, ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 50)]
    
    public init() {}
    
    // MARK: functions
    open func setupCamera(camera: some MainCameraBase) {}
    open func update(camera: some MainCameraBase) {}
    open func draw(encoder: MTLRenderCommandEncoder) {}
    
    open func updateAndDrawLight(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes([LIGHTS.count], length: MemoryLayout<Int>.stride, index: 2)
        encoder.setFragmentBytes(LIGHTS, length: Light.memorySize * LIGHTS.count, index: 3)
    }
    
    #if os(macOS)
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
    #endif
    
    #if os(iOS)
    open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    #endif
}
