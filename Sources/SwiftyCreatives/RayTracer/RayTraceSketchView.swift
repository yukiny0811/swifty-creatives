//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

import MetalKit
import SwiftUI
import AppKit

public struct RayTraceSketchView: ViewRepresentable {
    let renderer: RayTraceRenderer
    let drawProcess: RayTraceSketch
    public init(
        _ sketch: RayTraceSketch
    ) {
        self.drawProcess = sketch
        self.renderer = RayTraceRenderer(drawProcess: sketch)
    }
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = RayTraceMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
}
