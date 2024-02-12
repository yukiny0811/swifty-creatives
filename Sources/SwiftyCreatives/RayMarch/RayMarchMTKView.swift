//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

import MetalKit

public class RayMarchMTKView: MTKView {
    var renderer: RayMarchRenderer
    init(renderer: RayMarchRenderer) {
        self.renderer = renderer
        super.init(frame: .zero, device: ShaderCore.device)
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = 60
        self.autoResizeDrawable = true
        self.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.sampleCount = 1
        self.clearDepth = 1.0
        self.layer?.isOpaque = false
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
