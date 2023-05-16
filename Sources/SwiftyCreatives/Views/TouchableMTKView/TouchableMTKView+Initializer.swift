//
//  TouchableMTKView+Initializer.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

import MetalKit

extension TouchableMTKView {
    func initializeView() {
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = DrawConfig.frameRate
        self.autoResizeDrawable = true
        self.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.sampleCount = 1
        self.clearDepth = 1.0
        setOpaque()
    }
    func setOpaque() {
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
    }
}
