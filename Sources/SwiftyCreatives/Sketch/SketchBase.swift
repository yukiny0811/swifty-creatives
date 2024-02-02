//
//  SketchBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import MetalKit

public protocol SketchBase: AnyObject {
    var deltaTime: Float { get set }
    
    // MARK: functions
    #if !os(visionOS)
    func setupCamera(camera: MainCamera)
    func update(camera: MainCamera)
    #else
    func update()
    #endif
    func draw(encoder: SCEncoder)
    func updateAndDrawLight(encoder: SCEncoder)
    func beforeDraw(encoder: SCEncoder)
    func preProcess(commandBuffer: MTLCommandBuffer)
    func postProcess(texture: MTLTexture, commandBuffer: MTLCommandBuffer)
    
    #if canImport(XCTest)
    func afterCommit()
    #endif
    
    #if os(macOS)
    func mouseMoved(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func mouseDown(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func mouseDragged(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func mouseUp(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func mouseEntered(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func mouseExited(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func keyDown(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func keyUp(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    func viewWillStartLiveResize(camera: MainCamera, viewFrame: CGRect)
    func resize(withOldSuperviewSize oldSize: NSSize, camera: MainCamera, viewFrame: CGRect)
    func viewDidEndLiveResize(camera: MainCamera, viewFrame: CGRect)
    func scrollWheel(with event: NSEvent, camera: MainCamera, viewFrame: CGRect)
    #endif

    #if os(iOS)
    func onScroll(delta: CGPoint, camera: MainCamera, view: UIView, gestureRecognizer: UIPanGestureRecognizer)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView)
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView)
    #endif
}
