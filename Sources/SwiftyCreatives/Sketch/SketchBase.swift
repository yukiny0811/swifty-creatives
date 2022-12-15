//
//  SketchBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public protocol SketchBase {
    init()
    func setup()
    func update()
    func draw(encoder: MTLRenderCommandEncoder)
}

extension SketchBase {
    
    func cameraProcess(camera: MainCamera<some CameraConfigBase>) {}
    
    #if os(macOS)
    func mouseDown(with event: NSEvent) {}
    func mouseDragged(with event: NSEvent) {}
    func mouseUp(with event: NSEvent) {}
    func mouseEntered(with event: NSEvent) {}
    func mouseExited(with event: NSEvent) {}
    func keyDown(with event: NSEvent) {}
    func keyUp(with event: NSEvent) {}
    func viewWillStartLiveResize() {}
    func resize(withOldSuperviewSize oldSize: NSSize) {}
    func viewDidEndLiveResize() {}
    #endif
    
    #if os(iOS)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    #endif
}
