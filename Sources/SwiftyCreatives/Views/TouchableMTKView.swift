//
//  TouchableMTKView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

public class TouchableMTKView: MTKView {
    
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
        self.clearColor = MTLClearColor()
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.sampleCount = 1
        self.clearDepth = 1.0
        
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(macOS)
    public override func mouseDown(with event: NSEvent) {
        renderer.drawProcess.mouseDown(with: event)
    }
    public override func mouseDragged(with event: NSEvent) {
        renderer.camera.rotateAroundX(Float(event.deltaY) * 0.01)
        renderer.camera.rotateAroundY(Float(event.deltaX) * 0.01)
        renderer.drawProcess.mouseDragged(with: event)
    }
    public override func mouseUp(with event: NSEvent) {
        renderer.drawProcess.mouseUp(with: event)
    }
    public override func mouseEntered(with event: NSEvent) {
        renderer.drawProcess.mouseEntered(with: event)
    }
    public override func mouseExited(with event: NSEvent) {
        renderer.drawProcess.mouseExited(with: event)
    }
    public override func keyDown(with event: NSEvent) {
        renderer.drawProcess.keyDown(with: event)
    }
    public override func keyUp(with event: NSEvent) {
        renderer.drawProcess.keyUp(with: event)
    }
    public override func viewWillStartLiveResize() {
        renderer.drawProcess.viewWillStartLiveResize()
    }
    public override func resize(withOldSuperviewSize oldSize: NSSize) {
        renderer.drawProcess.resize(withOldSuperviewSize: oldSize)
    }
    public override func viewDidEndLiveResize() {
        renderer.drawProcess.viewDidEndLiveResize()
    }
    #endif
    
    #if os(iOS)
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesBegan(touches, with: event)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self) - touch.previousLocation(in: self)
        renderer.camera.rotateAroundX(Float(diff.y) * 0.01)
        renderer.camera.rotateAroundY(Float(diff.x) * 0.01)
        renderer.drawProcess.touchesMoved(touches, with: event)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesEnded(touches, with: event)
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesCancelled(touches, with: event)
    }
    #endif
}
