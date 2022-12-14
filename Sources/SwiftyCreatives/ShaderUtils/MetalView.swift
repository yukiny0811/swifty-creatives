//
//  File.swift
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
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: Alias.ViewRepresentable {
    
    typealias SomeRenderer = Renderer<DrawProcess, CameraConfig, DrawConfig>
    
    public typealias NSViewType = MTKView
    var renderer: SomeRenderer
    
    public init() {
        self.renderer = SomeRenderer()
    }
    
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

class TouchableMTKView<
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: MTKView {
    
    typealias SomeRenderer = Renderer<DrawProcess, CameraConfig, DrawConfig>
    
    init(renderer: SomeRenderer) {
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
        self.clearDepth = 1.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(macOS)
    override func mouseDragged(with event: NSEvent) {
        (self.delegate as! SomeRenderer).camera.rotateAroundX(Float(event.deltaY) * 0.01)
        (self.delegate as! SomeRenderer).camera.rotateAroundY(Float(event.deltaX) * 0.01)
    }
    #elseif os(iOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self) - touch.previousLocation(in: self)
        (self.delegate as! SomeRenderer).camera.rotateAroundX(Float(diff.y) * 0.01)
        (self.delegate as! SomeRenderer).camera.rotateAroundY(Float(diff.x) * 0.01)
    }
    #endif
}
