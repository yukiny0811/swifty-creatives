//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

import MetalKit
import SwiftUI
import AppKit

public struct RayMarchSketchView: ViewRepresentable {
    let renderer: RayMarchRenderer
    let drawProcess: RayMarchSketch
    public init(
        _ sketch: RayMarchSketch
    ) {
        self.drawProcess = sketch
        self.renderer = RayMarchRenderer(sketch: sketch)
    }
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = RayMarchMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
}
