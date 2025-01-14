//
//  RendererBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit

#if os(visionOS)

import CompositorServices
import Spatial

public class RendererBase {
    
    public var drawProcess: Sketch
    
    let arSession: ARKitSession
    let worldTracking: WorldTrackingProvider
    let layerRenderer: LayerRenderer
    
    public init(sketch: Sketch, layerRenderer: LayerRenderer) {
        self.drawProcess = sketch
        self.layerRenderer = layerRenderer
        worldTracking = WorldTrackingProvider()
        arSession = ARKitSession()
        
        
    }
    
    public func startRenderLoop() {
        Task {
            do {
                try await arSession.run([worldTracking])
            } catch {
                fatalError("Failed to initialize ARSession")
            }
            
            let renderThread = Thread {
                self.renderLoop()
            }
            renderThread.name = "Render Thread"
            renderThread.start()
        }
    }
    
    func renderLoop() {
        while true {
            if layerRenderer.state == .invalidated {
                print("Layer is invalidated")
                return
            } else if layerRenderer.state == .paused {
                layerRenderer.waitUntilRunning()
                continue
            } else {
                autoreleasepool {
                    self.renderFrame()
                }
            }
        }
    }
    func renderFrame() {
        
    }
}
#else
public class RendererBase: NSObject, MTKViewDelegate {
    var camera: MainCamera
    public var drawProcess: Sketch
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
