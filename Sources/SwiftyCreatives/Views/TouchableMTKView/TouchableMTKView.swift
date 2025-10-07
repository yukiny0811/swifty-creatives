//
//  TouchableMTKView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

#if !os(visionOS)

public class TouchableMTKView: MTKView {

    var renderer: RendererBase

    private var prevMagnification: Float = 1.0

    init(renderer: RendererBase) {
        self.renderer = renderer
        super.init(frame: .zero, device: ShaderCore.device)
        initializeView()
        configure()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deinitView()
    }
    
    #if os(macOS)
    
    private func getNormalizedMouseLocation(event: NSEvent) -> f2 {
        let viewOriginInWindow = self.convert(NSPoint.zero, to: event.window!.contentView)
        let mouseLocationInWindow = event.locationInWindow
        
        var localMouseLocation = mouseLocationInWindow
        localMouseLocation.x -= viewOriginInWindow.x
        localMouseLocation.y -= window!.contentView!.frame.maxY - viewOriginInWindow.y
        
        let normalizedLocation = NSPoint(x: localMouseLocation.x / self.frame.maxX, y: localMouseLocation.y / self.frame.maxY)
        return normalizedLocation.f2Value
    }
    
    override public var acceptsFirstResponder: Bool { return true }
    public override func mouseDown(with event: NSEvent) {
        renderer.drawProcess.mouseDown(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
    }
    public override func mouseMoved(with event: NSEvent) {
        renderer.drawProcess.mouseMoved(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
    }
    public override func mouseDragged(with event: NSEvent) {
        let moveRadX = Float(event.deltaY) * 0.01
        let moveRadY = Float(event.deltaX) * 0.01
        switch renderer.camera.config.easyCameraType {
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
        renderer.drawProcess.mouseDragged(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
    }
    public override func mouseUp(with event: NSEvent) {
        renderer.drawProcess.mouseUp(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
    }
    public override func mouseEntered(with event: NSEvent) {
        renderer.drawProcess.mouseEntered(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
    }
    public override func mouseExited(with event: NSEvent) {
        renderer.drawProcess.mouseExited(camera: renderer.camera, location: getNormalizedMouseLocation(event: event))
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
        switch renderer.camera.config.easyCameraType {
        case .manual:
            break
        case .easy(_), .flexible:
            renderer.camera.translate(0, 0, Float(event.deltaY) * 0.1)
            renderer.camera.translate(0, 0, -Float(event.deltaX) * 0.01)
        }
        renderer.drawProcess.scrollWheel(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    public override func magnify(with event: NSEvent) {
        renderer.drawProcess.magnify(with: event, camera: renderer.camera, viewFrame: self.superview!.frame)
    }
    #endif
    
    #if os(iOS)
    private func getTouchLocations(touches: Set<UITouch>) -> [f2] {
        var locations: [f2] = []
        for touch in touches {
            var location = touch.location(in: self)
            location.x /= self.frame.width
            location.y /= self.frame.height
            location.y = 1 - location.y
            locations.append(location.f2Value)
        }
        return locations
    }
    @objc func onScroll(recognizer: UIPanGestureRecognizer) {
        let delta = recognizer.velocity(in: self)
        switch renderer.camera.config.easyCameraType {
        case .manual:
            break
        case .easy(_), .flexible:
            renderer.camera.translate(0, 0, Float(delta.y) * 0.001)
            renderer.camera.translate(0, 0, -Float(delta.x) * 0.0001)
        }
        renderer.drawProcess.onScroll(delta: delta, camera: renderer.camera, view: self, gestureRecognizer: recognizer)
    }
    @objc func onPinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            prevMagnification = 1.0
        case .changed:
            let delta = Float(recognizer.scale) / prevMagnification
            prevMagnification = Float(recognizer.scale)
            renderer.drawProcess.onPinch(magnificationDelta: delta, camera: renderer.camera, view: self, gestureRecognizer: recognizer)
        default:
            prevMagnification = 1.0
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesBegan(camera: renderer.camera, touchLocations: getTouchLocations(touches: touches))
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let diff = touch.location(in: self).f2Value - touch.previousLocation(in: self).f2Value
        let moveRadX = diff.y * 0.01
        let moveRadY = diff.x * 0.01
        switch renderer.camera.config.easyCameraType {
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
        renderer.drawProcess.touchesMoved(camera: renderer.camera, touchLocations: getTouchLocations(touches: touches))
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesEnded(camera: renderer.camera, touchLocations: getTouchLocations(touches: touches))
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.drawProcess.touchesCancelled(camera: renderer.camera, touchLocations: getTouchLocations(touches: touches))
    }
    #endif
}

#endif
