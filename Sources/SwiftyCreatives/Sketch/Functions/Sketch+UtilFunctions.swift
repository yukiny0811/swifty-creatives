//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

#if os(macOS)
import AppKit
#endif

public extension Sketch {
    #if os(macOS)
    func mousePos(event: NSEvent, viewFrame: NSRect) -> f2 {
        var location = event.locationInWindow
        location.y = event.window!.contentRect(forFrameRect: event.window!.frame).height - location.y
        location -= CGPoint(x: viewFrame.minX, y: viewFrame.minY)
        return f2(Float(location.x), Float(location.y))
    }
    #endif
}
