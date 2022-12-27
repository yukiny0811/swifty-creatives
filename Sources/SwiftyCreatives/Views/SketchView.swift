//
//  MetalView.swift
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
    DrawProcess: SketchBase,
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: ViewRepresentable {
    
    var renderer: any RendererBase {
        DrawConfig.blendMode.getRenderer(
            p: DrawProcess.self,
            c: CameraConfig.self,
            d: DrawConfig.self
        )
    }
    
    public init() {}
    
    public init(cameraConfig: CameraConfig.Type = MainCameraConfig.self, drawConfig: DrawConfig.Type = MainDrawConfig.self) {}
    
    #if os(macOS)
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView<CameraConfig>(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {
    }
    #elseif os(iOS)
    public func makeUIView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView<CameraConfig>(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: MTKView, context: Context) {
    }
    #endif
}
