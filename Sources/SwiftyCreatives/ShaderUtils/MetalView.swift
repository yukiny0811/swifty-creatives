//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import MetalKit
import AppKit
import SwiftUI

@available(macOS 10.15, *)
public struct MetalView<
    DrawProcess: ProcessBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSViewRepresentable {
    
    typealias SomeRenderer = Renderer<DrawProcess, CameraConfig, DrawConfig>
    
    public typealias NSViewType = MTKView
    var renderer: SomeRenderer
    
    public init() {
        self.renderer = SomeRenderer()
    }
    
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView(renderer: renderer)
        return mtkView
    }
    
    public func updateNSView(_ nsView: MTKView, context: Context) {
        
    }
}

@available(macOS 10.15, *)
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
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = true
        self.preferredFramesPerSecond = 120
        self.autoResizeDrawable = true
        self.layer?.isOpaque = false
        self.clearColor = MTLClearColor()
        self.depthStencilPixelFormat = .depth32Float
        self.clearDepth = 1.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDragged(with event: NSEvent) {
        (self.delegate as! SomeRenderer).camera.rotateAroundX(Float(event.deltaY) * 0.01)
        (self.delegate as! SomeRenderer).camera.rotateAroundY(Float(event.deltaX) * 0.01)
    }
}
