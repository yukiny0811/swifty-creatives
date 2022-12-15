//
//  MetalView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import MetalKit
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct MetalView<
    DrawProcess: SketchBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: ViewRepresentable {
    
    public typealias NSViewType = MTKView
    
    var renderer: any RendererBase {
        DrawConfig.blendMode.getRenderer(
            p: DrawProcess.self,
            c: CameraConfig.self,
            d: DrawConfig.self
        )
    }
    
    public init() {}
    
    #if os(macOS)
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {
    }
    #elseif os(iOS)
    public func makeUIView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: MTKView, context: Context) {
    }
    #endif
}

class TouchableMTKView: MTKView {
    
    var renderer: any RendererBase
    
    init(renderer: any RendererBase) {
        self.renderer = renderer
        super.init(frame: .zero, device: ShaderCore.device)
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.colorPixelFormat = .bgra8Unorm_srgb
        self.framebufferOnly = true
        self.preferredFramesPerSecond = 120
        self.autoResizeDrawable = true
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
        self.clearColor = MTLClearColor()
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.sampleCount = 1
        self.clearDepth = 1.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        renderer.drawProcess.mouseDown(with: event)
    }
    override func mouseDragged(with event: NSEvent) {
        renderer.camera.rotateAroundX(Float(event.deltaY) * 0.01)
        renderer.camera.rotateAroundY(Float(event.deltaX) * 0.01)
        renderer.drawProcess.mouseDragged(with: event)
    }
    override func mouseUp(with event: NSEvent) {
        renderer.drawProcess.mouseUp(with: event)
    }
    override func mouseEntered(with event: NSEvent) {
        renderer.drawProcess.mouseEntered(with: event)
    }
    override func mouseExited(with event: NSEvent) {
        renderer.drawProcess.mouseExited(with: event)
    }
    override func keyDown(with event: NSEvent) {
        renderer.drawProcess.keyDown(with: event)
    }
    override func keyUp(with event: NSEvent) {
        renderer.drawProcess.keyUp(with: event)
    }
    override func viewWillStartLiveResize() {
        renderer.drawProcess.viewWillStartLiveResize()
    }
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        renderer.drawProcess.resize(withOldSuperviewSize: oldSize)
    }
    override func viewDidEndLiveResize() {
        renderer.drawProcess.viewDidEndLiveResize()
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self) - touch.previousLocation(in: self)
        renderer.camera.rotateAroundX(Float(diff.y) * 0.01)
        renderer.camera.rotateAroundY(Float(diff.x) * 0.01)
        renderer.drawProcess.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesCancelled(touches, with: event)
    }
    #endif
}
