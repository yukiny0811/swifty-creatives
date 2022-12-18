//
//  File.swift
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
>: TouchableMTKView {
    
    var _renderer: any RendererBase
    
    public init() {
        _renderer = DrawConfig.blendMode.getRenderer(
            p: DrawProcess.self,
            c: CameraConfig.self,
            d: DrawConfig.self
        )
        super.init(renderer: _renderer)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}