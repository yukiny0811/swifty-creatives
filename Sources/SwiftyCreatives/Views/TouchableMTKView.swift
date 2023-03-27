//
//  TouchableMTKView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

public class TouchableMTKView<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: MTKView {
    var renderer: RendererBase<CameraConfig, DrawConfig>
    init(renderer: RendererBase<CameraConfig, DrawConfig>) {
        self.renderer = renderer
        super.init(frame: .zero, device: ShaderCore.device)
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
        
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
        
        #if os(macOS)
        configureMacOS()
        #endif
        
        #if os(iOS)
        configureiOS()
        #endif
    }
    
    
    #if os(macOS)
    func configureMacOS() {
        let options: NSTrackingArea.Options = [
            .mouseMoved,
            .activeAlways,
            .inVisibleRect
        ]
        let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    #endif
    
    #if os(iOS)
    func configureiOS() {
        let scrollGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onScroll))
        scrollGestureRecognizer.allowedScrollTypesMask = .continuous
        scrollGestureRecognizer.minimumNumberOfTouches = 2
        scrollGestureRecognizer.maximumNumberOfTouches = 2
        self.addGestureRecognizer(scrollGestureRecognizer)
    }
    #endif
    
    @available(*, unavailable)
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
    public override func mouseMoved(with event: NSEvent) {
        renderer.drawProcess.mouseMoved(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func mouseDragged(with event: NSEvent) {
        let moveRadX = Float(event.deltaY) * 0.01
        let moveRadY = Float(event.deltaX) * 0.01
        switch CameraConfig.easyCameraType {
        case .manual:
            break
        case .easy(polarSpacing: let polarSpacing):
            if checkIfExceedsPolarSpacing(rad: moveRadX, polarSpacing: polarSpacing) == false {
                renderer.camera.rotateAroundVisibleX(moveRadX)
            }
            renderer.camera.rotateAroundY(moveRadY)
        case .flexible:
            renderer.camera.rotateAroundVisibleX(moveRadX)
            renderer.camera.rotateAroundVisibleY(moveRadY)
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
    public override func scrollWheel(with event: NSEvent) {
        switch CameraConfig.easyCameraType {
        case .manual:
            break
        case .easy(_), .flexible:
            renderer.camera.translate(0, 0, Float(event.deltaY) * 0.1)
            renderer.camera.translate(0, 0, -Float(event.deltaX) * 0.01)
        }
        renderer.drawProcess.scrollWheel(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    #endif
    
    #if os(iOS)
    @objc func onScroll(recognizer: UIPanGestureRecognizer) {
        let delta = recognizer.velocity(in: self)
        switch CameraConfig.easyCameraType {
        case .manual:
            break
        case .easy(_), .flexible:
            renderer.camera.translate(0, 0, Float(delta.y) * 0.001)
            renderer.camera.translate(0, 0, -Float(delta.x) * 0.0001)
        }
        renderer.drawProcess.onScroll(delta: delta, camera: renderer.camera, view: self, gestureRecognizer: recognizer)
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesBegan(touches, with: event, camera: renderer.camera, view: self)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self) - touch.previousLocation(in: self)
        let moveRadX = Float(diff.y) * 0.01
        let moveRadY = Float(diff.x) * 0.01
        switch CameraConfig.easyCameraType {
        case .manual:
            break
        case .easy(polarSpacing: let polarSpacing):
            if checkIfExceedsPolarSpacing(rad: moveRadX, polarSpacing: polarSpacing) == false {
                renderer.camera.rotateAroundVisibleX(moveRadX)
            }
            renderer.camera.rotateAroundY(moveRadY)
        case .flexible:
            renderer.camera.rotateAroundVisibleX(moveRadX)
            renderer.camera.rotateAroundVisibleY(moveRadY)
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
    
    private func checkIfExceedsPolarSpacing(rad: Float, polarSpacing: Float) -> Bool {
        let mockedMainMatrix = renderer.camera.mock_rotateAroundVisibleX(rad)
        let detectionValue = mockedMainMatrix.columns.1.y
        if detectionValue < polarSpacing {
            return true
        }
        return false
    }
}
