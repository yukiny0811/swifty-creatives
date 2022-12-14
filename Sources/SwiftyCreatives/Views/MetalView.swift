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
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: ViewRepresentable {
    
    public typealias NSViewType = MTKView
    var renderer: any RendererBase {
        switch DrawConfig.blendMode {
        case .normalBlend:
            return Renderer<DrawProcess, CameraConfig, DrawConfig>()
        case .add:
            return Renderer<DrawProcess, CameraConfig, DrawConfig>()
        case .alphaBlend:
            return TransparentRenderer<DrawProcess, CameraConfig, DrawConfig>()
        }
    }
    
    public init() {
        
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
    override func mouseDragged(with event: NSEvent) {
        renderer.camera.rotateAroundX(Float(event.deltaY) * 0.01)
        renderer.camera.rotateAroundY(Float(event.deltaX) * 0.01)
    }
    #elseif os(iOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self) - touch.previousLocation(in: self)
        renderer.camera.rotateAroundX(Float(diff.y) * 0.01)
        renderer.camera.rotateAroundY(Float(diff.x) * 0.01)
    }
    #endif
}
