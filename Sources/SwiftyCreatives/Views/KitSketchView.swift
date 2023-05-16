//
//  KitSketchView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import MetalKit

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public class KitSketchView<
    DrawProcess: SketchBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: TouchableMTKView<CameraConfig, DrawConfig> {
    var thisRenderer: RendererBase<CameraConfig, DrawConfig>
    public init(_ sketch: SketchBase) {
        thisRenderer = DrawConfig.blendMode.getRenderer(
            sketch: sketch
        )
        super.init(renderer: thisRenderer)
    }
}
