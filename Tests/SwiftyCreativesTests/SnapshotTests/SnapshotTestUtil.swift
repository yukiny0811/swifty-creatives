//
//  SnapshotTestUtil.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

import XCTest
import MetalKit
@testable import SwiftyCreatives

#if os(macOS)

enum SnapshotTestUtil {
    
    static let isRecording = false

    static func testGPU() throws {
        try XCTSkipIf(MTLCreateSystemDefaultDevice() == nil)
    }
    
    static func render(sketch: SketchForTest) {
        let swiftuiView = SketchView(sketch, blendMode: .normalBlend)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
    }
}

#endif
