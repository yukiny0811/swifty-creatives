//
//  TouchableMTKView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

public class TouchableMTKView<CameraConfig: CameraConfigBase>: MTKView {
    
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
        self.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.sampleCount = 1
        self.clearDepth = 1.0
        
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
        
        #if os(iOS)
        let scrollGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onScroll))
        scrollGestureRecognizer.allowedScrollTypesMask = .continuous
        scrollGestureRecognizer.minimumNumberOfTouches = 2
        scrollGestureRecognizer.maximumNumberOfTouches = 2
        self.addGestureRecognizer(scrollGestureRecognizer)
        #endif
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if os(iOS)
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer)
            }
        }
        #endif
    }
    
    #if os(macOS)
    override public var acceptsFirstResponder: Bool { return true }
    public override func mouseDown(with event: NSEvent) {
        renderer.drawProcess.mouseDown(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func mouseDragged(with event: NSEvent) {
        if CameraConfig.enableEasyMove {
            renderer.camera.rotateAroundX(Float(event.deltaY) * 0.01)
            renderer.camera.rotateAroundY(Float(event.deltaX) * 0.01)
        }
        renderer.drawProcess.mouseDragged(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func mouseUp(with event: NSEvent) {
        renderer.drawProcess.mouseUp(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func mouseEntered(with event: NSEvent) {
        renderer.drawProcess.mouseEntered(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func mouseExited(with event: NSEvent) {
        renderer.drawProcess.mouseExited(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func keyDown(with event: NSEvent) {
        renderer.drawProcess.keyDown(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func keyUp(with event: NSEvent) {
        renderer.drawProcess.keyUp(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func viewWillStartLiveResize() {
        renderer.drawProcess.viewWillStartLiveResize(camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func resize(withOldSuperviewSize oldSize: NSSize) {
        renderer.drawProcess.resize(withOldSuperviewSize: oldSize, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func viewDidEndLiveResize() {
        renderer.drawProcess.viewDidEndLiveResize(camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    #endif
    
    #if os(iOS)
    @objc func onScroll(recognizer: UIPanGestureRecognizer) {
        let delta = recognizer.translation(in: self)
        renderer.drawProcess.onScroll(delta: delta, camera: renderer.camera, view: self, gestureRecognizer: recognizer)
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesBegan(touches, with: event, camera: renderer.camera, view: self)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if CameraConfig.enableEasyMove {
            let touch = touches.first!
            let diff = touch.location(in: self) - touch.previousLocation(in: self)
            renderer.camera.rotateAroundX(Float(diff.y) * 0.01)
            renderer.camera.rotateAroundY(Float(diff.x) * 0.01)
        }
        renderer.drawProcess.touchesMoved(touches, with: event, camera: renderer.camera, view: self)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesEnded(touches, with: event, camera: renderer.camera, view: self)
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesCancelled(touches, with: event, camera: renderer.camera, view: self)
    }
    #endif
}
