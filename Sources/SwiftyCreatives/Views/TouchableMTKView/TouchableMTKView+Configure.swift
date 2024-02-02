//
//  TouchableMTKView+Configure.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

import MetalKit

#if !os(visionOS)

extension TouchableMTKView {
    func configure() {
        #if os(macOS)
        configureMacOS()
        #elseif os(iOS)
        configureiOS()
        #endif
    }
}

extension TouchableMTKView {
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
}

#endif
