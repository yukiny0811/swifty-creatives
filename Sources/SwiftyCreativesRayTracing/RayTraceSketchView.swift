//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import MetalKit
import SwiftUI
import SwiftyCreatives
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct RayTraceSketchView: ViewRepresentable {
    let renderer: RayTraceRenderer
    let drawProcess: RayTraceSketch
    public init(
        _ sketch: RayTraceSketch
    ) {
        self.drawProcess = sketch
        self.renderer = RayTraceRenderer(drawProcess: sketch)
    }
    #if os(macOS)
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = RayTraceMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
    #else
    public func makeUIView(context: Context) -> some UIView {
        let mtkView = RayTraceMTKView(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
    #endif
}
