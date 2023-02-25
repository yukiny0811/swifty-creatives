//
//  SketchView.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import MetalKit
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct SketchView<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: ViewRepresentable {
    
    let renderer: RendererBase<CameraConfig, DrawConfig>
    
    let drawProcess: SketchBase
    
    public init(_ sketch: SketchBase) {
        self.drawProcess = sketch
        self.renderer = DrawConfig.blendMode.getRenderer(
            c: CameraConfig.self,
            d: DrawConfig.self,
            sketch: self.drawProcess
        )
    }
    
    #if os(macOS)
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView<CameraConfig, DrawConfig>(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {
    }
    #elseif os(iOS)
    public func makeUIView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView<CameraConfig, DrawConfig>(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: MTKView, context: Context) {
    }
    #endif
}
