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
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    
    public override init(sketch: Sketch, layerRenderer: LayerRenderer) {
        
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "normal_vertex")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "normal_fragment")
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .greater, writeDepth: true)
        self.depthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        super.init(sketch: sketch, layerRenderer: layerRenderer)
    }
    
    override func renderFrame() {
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
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDescriptor.depthAttachment.texture = drawable.depthTextures[0]
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .store
        renderPassDescriptor.depthAttachment.clearDepth = 0.0
        renderPassDescriptor.rasterizationRateMap = drawable.rasterizationRateMaps.first
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
        
        let viewports = drawable.views.map { $0.textureMap.viewport }
        renderCommandEncoder?.setViewport(viewports[0])
        
        drawProcess.beforeDraw(encoder: renderCommandEncoder!)
        drawProcess.update()
        drawProcess.draw(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        
        self.drawProcess.postProcess(texture: renderPassDescriptor.colorAttachments[0].texture!, commandBuffer: commandBuffer!)
        
        drawable.encodePresent(commandBuffer: commandBuffer!)
        commandBuffer!.commit()
        
        commandBuffer!.waitUntilCompleted()
        self.drawProcess.afterCommit(texture: renderPassDescriptor.colorAttachments[0].texture)
        
        frame.endSubmission()
    }
}

#endif
