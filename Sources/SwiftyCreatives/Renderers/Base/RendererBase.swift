//
//  RendererBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit
import simd

public class RendererBase<
    CameraConfig: CameraConfigBase,
    DrawConfig: DrawConfigBase
>: NSObject, MTKViewDelegate {
    var camera: MainCamera<CameraConfig>
    var drawProcess: SketchBase
    var savedDate: Date
    public var cachedTexture: MTLTexture?
    public init(drawProcess: SketchBase) {
        self.camera = MainCamera()
        self.drawProcess = drawProcess
        self.savedDate = Date()
    }
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    public func draw(in view: MTKView) {
        calculateDeltaTime()
        view.drawableSize = CGSize(
            width: view.frame.size.width * CGFloat(DrawConfig.contentScaleFactor),
            height: view.frame.size.height * CGFloat(DrawConfig.contentScaleFactor)
        )
        camera.setFrame(
            width: Float(view.frame.size.width) * Float(DrawConfig.contentScaleFactor),
            height: Float(view.frame.size.height) * Float(DrawConfig.contentScaleFactor)
        )
    }
}
