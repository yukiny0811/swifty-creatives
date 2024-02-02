//
//  RendererBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit
import simd

#if os(visionOS)
public class RendererBase {
    var drawProcess: Sketch
    public init(drawProcess: Sketch) {
        self.drawProcess = drawProcess
    }
}
#else
public class RendererBase: NSObject, MTKViewDelegate {
    var camera: MainCamera
    var drawProcess: Sketch
    var savedDate: Date
    var drawConfig: DrawConfig
    public var cachedTexture: MTLTexture?
    public init(drawProcess: Sketch, cameraConfig: CameraConfig, drawConfig: DrawConfig) {
        self.camera = MainCamera(config: cameraConfig)
        self.drawConfig = drawConfig
        self.drawProcess = drawProcess
        self.savedDate = Date()
    }
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    public func draw(in view: MTKView) {
        calculateDeltaTime()
        view.drawableSize = CGSize(
            width: view.frame.size.width * CGFloat(drawConfig.contentScaleFactor),
            height: view.frame.size.height * CGFloat(drawConfig.contentScaleFactor)
        )
        camera.setFrame(
            width: Float(view.frame.size.width) * Float(drawConfig.contentScaleFactor),
            height: Float(view.frame.size.height) * Float(drawConfig.contentScaleFactor)
        )
    }
}
#endif
