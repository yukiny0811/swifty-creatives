//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import MetalKit
import SwiftyCreatives

public class RayTraceMTKView: MTKView {
    var renderer: RayTraceRenderer
    init(renderer: RayTraceRenderer) {
        self.renderer = renderer
        super.init(frame: .zero, device: SwiftyCreatives.ShaderCore.device)
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = 60
        self.autoResizeDrawable = true
        self.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.sampleCount = 1
        self.clearDepth = 1.0
        #if os(macOS)
        self.layer?.isOpaque = false
        #else
        self.layer.isOpaque = false
        #endif
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}