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

public class KitSketchView<
    DrawConfig: DrawConfigBase
>: TouchableMTKView<DrawConfig> {
    var thisRenderer: RendererBase<DrawConfig>
    public init(_ sketch: SketchBase) {
        thisRenderer = DrawConfig.blendMode.getRenderer(
            sketch: sketch
        )
        super.init(renderer: thisRenderer)
    }
}

#endif
