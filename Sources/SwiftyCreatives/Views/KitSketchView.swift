//
//  KitSketchView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

#if !os(visionOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public class KitSketchView: TouchableMTKView {
    var thisRenderer: RendererBase
    public init(_ sketch: Sketch, blendMode: RendererBase.BlendMode, cameraConfig: CameraConfig, drawConfig: DrawConfig) {
        thisRenderer = blendMode.getRenderer(
            sketch: sketch,
            cameraConfig: cameraConfig,
            drawConfig: drawConfig
        )
        super.init(renderer: thisRenderer)
    }
}

#endif
