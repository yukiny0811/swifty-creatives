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

public class TransparentRendererVision: RendererBase {
    
    let renderPipelineDescriptor: MTLRenderPipelineDescriptor
    let vertexDescriptor: MTLVertexDescriptor
    let depthStencilState: MTLDepthStencilState
    let renderPipelineState: MTLRenderPipelineState
    
    var depthCacheTexture: MTLTexture!
    
    public override init(sketch: Sketch, layerRenderer: LayerRenderer) {
        
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = layerRenderer.configuration.colorFormat
        renderPipelineDescriptor.colorAttachments[1].pixelFormat = .r32Float
        renderPipelineDescriptor.depthAttachmentPixelFormat = layerRenderer.configuration.depthFormat
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        renderPipelineDescriptor.colorAttachments[1].isBlendingEnabled = true
        
        renderPipelineDescriptor.vertexFunction = ShaderCore.library.makeFunction(name: "transparent_vertex_vision")
        renderPipelineDescriptor.fragmentFunction = ShaderCore.library.makeFunction(name: "transparent_fragment")
        renderPipelineDescriptor.maxVertexAmplificationCount = layerRenderer.properties.viewCount
        renderPipelineDescriptor.inputPrimitiveTopology = .triangle
        
        vertexDescriptor = Self.createVertexDescriptor()
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        let depthStencilDescriptor = Self.createDepthStencilDescriptor(compareFunc: .always, writeDepth: true)
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
        
        
        if depthCacheTexture == nil {
            let descriptor = MTLTextureDescriptor()
            descriptor.pixelFormat = .r32Float
            descriptor.textureType = .type2DArray
            descriptor.width = drawable.colorTextures[0].width
            descriptor.height = drawable.colorTextures[0].height
            descriptor.arrayLength = drawable.views.count
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
            descriptor.resourceOptions = .storageModePrivate
            depthCacheTexture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        }

        //cb
        
        let commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()
        
        drawProcess.preProcess(commandBuffer: commandBuffer!)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.colorTextures[0]
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDescriptor.colorAttachments[1].texture = depthCacheTexture
        renderPassDescriptor.colorAttachments[1].loadAction = .clear
        renderPassDescriptor.colorAttachments[1].storeAction = .store
        renderPassDescriptor.colorAttachments[1].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDescriptor.depthAttachment.texture = drawable.depthTextures[0]
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .store
        renderPassDescriptor.depthAttachment.clearDepth = 0.0
        renderPassDescriptor.rasterizationRateMap = drawable.rasterizationRateMaps.first
        if layerRenderer.configuration.layout == .layered {
            renderPassDescriptor.renderTargetArrayLength = drawable.views.count
        }
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        Self.setDefaultBuffers(encoder: renderCommandEncoder!)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        renderCommandEncoder?.setCullMode(.front)
        
        let simdDeviceAnchor = deviceAnchor?.originFromAnchorTransform ?? matrix_identity_float4x4
        
        let viewMatrixs = drawable.views.map { (simdDeviceAnchor * $0.transform).inverse }
        let projectionTemps = drawable.views.map {
            ProjectiveTransform3D(
                leftTangent: Double($0.tangents[0]),
                rightTangent: Double($0.tangents[1]),
                topTangent: Double($0.tangents[2]),
                bottomTangent: Double($0.tangents[3]),
                nearZ: Double(drawable.depthRange.y),
                farZ: Double(drawable.depthRange.x),
                reverseZ: true
            )
        }
        let projections = projectionTemps.map { matrix_float4x4.init($0) }
        
        renderCommandEncoder?.setVertexBytes(projections, length: f4x4.memorySize * projections.count, index: VertexBufferIndex.ProjectionMatrix.rawValue)
        renderCommandEncoder?.setVertexBytes(viewMatrixs, length: f4x4.memorySize * projections.count, index: VertexBufferIndex.ViewMatrix.rawValue)
        
        let viewports = drawable.views.map { $0.textureMap.viewport }
        renderCommandEncoder?.setViewports(viewports)
        
        if drawable.views.count > 1 {
            var viewMappings = (0..<drawable.views.count).map {
                MTLVertexAmplificationViewMapping(viewportArrayIndexOffset: UInt32($0),
                                                  renderTargetArrayIndexOffset: UInt32($0))
            }
            renderCommandEncoder?.setVertexAmplificationCount(viewports.count, viewMappings: &viewMappings)
        }
        
        let cameraPosBuffer = ShaderCore.device.makeBuffer(bytes: [f3(0, 0, 0)], length: f3.memorySize)
        renderCommandEncoder?.setVertexBuffer(cameraPosBuffer, offset: 0, index: VertexBufferIndex.CameraPos.rawValue)
        renderCommandEncoder?.setFragmentTexture(AssetUtil.defaultMTLTexture, index: FragmentTextureIndex.MainTexture.rawValue)
        
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
