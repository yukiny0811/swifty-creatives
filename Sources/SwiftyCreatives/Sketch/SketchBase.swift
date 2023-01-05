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
    
    // MARK: functions
    func setupCamera(camera: some MainCameraBase)
    func update(camera: some MainCameraBase)
    
    func updateAndDrawLight(encoder: MTLRenderCommandEncoder)
    
    func draw(encoder: MTLRenderCommandEncoder)
    
    #if os(macOS)
    func mouseDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func mouseDragged(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func mouseUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func mouseEntered(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func mouseExited(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func keyDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func keyUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect)
    func viewWillStartLiveResize(camera: some MainCameraBase, viewFrame: CGRect)
    func resize(withOldSuperviewSize oldSize: NSSize, camera: some MainCameraBase, viewFrame: CGRect)
    func viewDidEndLiveResize(camera: some MainCameraBase, viewFrame: CGRect)
    #endif

    #if os(iOS)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect)
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect)
    #endif
}

public extension SketchBase {
    
    func updateAndDrawLight(encoder: MTLRenderCommandEncoder) {}
    
    #if os(macOS)
    func mouseDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func mouseDragged(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func mouseUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func mouseEntered(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func mouseExited(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func keyDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func keyUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    func viewWillStartLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    func resize(withOldSuperviewSize oldSize: NSSize, camera: some MainCameraBase, viewFrame: CGRect) {}
    func viewDidEndLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    #endif
    
    #if os(iOS)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, viewFrame: CGRect) {}
    #endif
}
