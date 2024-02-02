//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/02.
//

#if os(visionOS)

import MetalKit
import Spatial
import CompositorServices

public class NormalBlendRendererVision: RendererBase {
    
    let arSession: ARKitSession
    let worldTracking: WorldTrackingProvider
    let layerRenderer: LayerRenderer
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    
    public init(sketch: SketchBase, layerRenderer: LayerRenderer) {
        self.layerRenderer = layerRenderer
        worldTracking = WorldTrackingProvider()
        arSession = ARKitSession()
        
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "normal_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "normal_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .less, writeDepth: true)
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        super.init(drawProcess: sketch)
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
        /// Per frame updates hare

        guard let frame = layerRenderer.queryNextFrame() else { return }
        
        frame.startUpdate()
        
        // Perform frame independent work
        
        frame.endUpdate()
        
        guard let timing = frame.predictTiming() else { return }
        LayerRenderer.Clock().wait(until: timing.optimalInputTime)
        guard let drawable = frame.queryDrawable() else { return }
        frame.startSubmission()
        let time = LayerRenderer.Clock.Instant.epoch.duration(to: drawable.frameTiming.presentationTime).timeInterval
        let deviceAnchor = worldTracking.queryDeviceAnchor(atTimestamp: time)
        drawable.deviceAnchor = deviceAnchor
        
        
        //cb
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        drawProcess.preProcess(commandBuffer: commandBuffer!)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.colorTextures[0]
        renderPassDescriptor.depthAttachment.texture = drawable.depthTextures[0]
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        Self.setDefaultBuffers(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        
        let simdDeviceAnchor = deviceAnchor?.originFromAnchorTransform ?? matrix_identity_float4x4
        
        let view = drawable.views[0]
        let viewMatrix = (simdDeviceAnchor * view.transform).inverse
        let projectionTemp = ProjectiveTransform3D(leftTangent: Double(view.tangents[0]),
                                               rightTangent: Double(view.tangents[1]),
                                               topTangent: Double(view.tangents[2]),
                                               bottomTangent: Double(view.tangents[3]),
                                               nearZ: Double(drawable.depthRange.y),
                                               farZ: Double(drawable.depthRange.x),
                                               reverseZ: true)
        let projection = matrix_float4x4.init(projectionTemp)
        
        renderCommandEncoder?.setVertexBytes([projection], length: f4x4.memorySize, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderCommandEncoder?.setVertexBytes([viewMatrix], length: f4x4.memorySize, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [f3(0, 0, 0)], length: f3.memorySize)
        renderCommandEncoder?.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderCommandEncoder?.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
        drawProcess.beforeDraw(encoder: renderCommandEncoder!)
        drawProcess.update()
        drawProcess.draw(encoder: renderCommandEncoder!)
        
//        renderCommandEncoder?.setViewport(
//            MTLViewport(
//                originX: 0,
//                originY: 0,
//                width: Double(view.bounds.width) * Double(DrawConfig.contentScaleFactor),
//                height: Double(view.bounds.height) * Double(DrawConfig.contentScaleFactor),
//                znear: -1,
//                zfar: 1
//            )
//        )
        
        let viewports = drawable.views.map { $0.textureMap.viewport }
        renderCommandEncoder?.setViewport(viewports[0])
        
        renderCommandEncoder?.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer!)
        
//        if cachedTexture == nil || cachedTexture!.width != view.currentDrawable!.texture.width || cachedTexture!.height != view.currentDrawable!.texture.height {
//            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
//                pixelFormat: view.colorPixelFormat,
//                width: view.currentDrawable!.texture.width,
//                height: view.currentDrawable!.texture.height,
//                mipmapped: false)
//            textureDescriptor.usage = [.shaderRead]
//            cachedTexture = ShaderCore.device.makeTexture(descriptor: textureDescriptor)
//        }
        
//        let afterEncoder = commandBuffer!.makeBlitCommandEncoder()!
//        afterEncoder.copy(from: renderPassDescriptor.colorAttachments[0].texture!, to: cachedTexture!)
//        afterEncoder.copy(from: renderPassDescriptor.colorAttachments[0].texture!, to: view.currentDrawable!.texture)
//        afterEncoder.endEncoding()
        drawable.encodePresent(commandBuffer: commandBuffer!)
        commandBuffer!.commit()
        
        commandBuffer!.waitUntilCompleted()
//        self.drawProcess.afterCommit(texture: self.cachedTexture)
        
        frame.endSubmission()
    }
}

extension LayerRenderer.Clock.Instant.Duration {
    var timeInterval: TimeInterval {
        let nanoseconds = TimeInterval(components.attoseconds / 1_000_000_000)
        return TimeInterval(components.seconds) + (nanoseconds / TimeInterval(NSEC_PER_SEC))
    }
}

func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
    let unitAxis = normalize(axis)
    let ct = cosf(radians)
    let st = sinf(radians)
    let ci = 1 - ct
    let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
    return matrix_float4x4.init(columns:(vector_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                         vector_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                         vector_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                         vector_float4(                  0,                   0,                   0, 1)))
}

func matrix4x4_translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> matrix_float4x4 {
    return matrix_float4x4.init(columns:(vector_float4(1, 0, 0, 0),
                                         vector_float4(0, 1, 0, 0),
                                         vector_float4(0, 0, 1, 0),
                                         vector_float4(translationX, translationY, translationZ, 1)))
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}

#endif
