//
//  Sketch+UtilFunctions.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

#if os(macOS)
import AppKit
import SimpleSimdSwift

public extension Sketch {
    func mousePos(event: NSEvent, viewFrame: NSRect, isPerspective: Bool = true, loc: NSPoint) -> f2 {
        var location = loc
        if isPerspective {
            location.y = event.window!.contentRect(
                forFrameRect: event.window!.frame
            ).height - location.y
            location.x -= viewFrame.minX
            location.y -= viewFrame.minY
            return f2(Float(location.x), Float(location.y))
        } else {
            let contentRect = event.window!.contentRect(forFrameRect: event.window!.frame)
            var adjustedLocation = f2(
                Float(location.x),
                Float(contentRect.height - location.y)
            )
            adjustedLocation.x -= Float(viewFrame.minX)
            adjustedLocation.y -= Float(viewFrame.minY)
            let normalizedLocation: f2 = f2(
                adjustedLocation.x / Float(viewFrame.width),
                1 - (adjustedLocation.y / Float(viewFrame.height))
            )
            let signedNormalizedLocation = normalizedLocation * 2 - f2.one
            return f2(signedNormalizedLocation.x * metalDrawableSize.x / 2, signedNormalizedLocation.y * metalDrawableSize.y / 2)
        }
    }
}
#endif
