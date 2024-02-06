//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import MetalKit

struct SkyBox {
    
    let skyMesh: MTKMesh
    var skyTexture: MTLTexture
    let skyboxPipelineState: MTLRenderPipelineState
    let skyboxDepthStencilState: MTLDepthStencilState
    public var skySettings = SkyBox.SkySettings()
    
    init(textureReference: TextureReference?) throws {
        let allocator = MTKMeshBufferAllocator(device: ShaderCore.device)
        let skyCube = MDLMesh(
            boxWithExtent: [1, 1, 1],
            segments: [1, 1, 1],
            inwardNormals: true,
            geometryType: .triangles,
            allocator: allocator
        )
        
        let skyVertexFunction = ShaderCore.library.makeFunction(name: "vertex_skybox")!
        let skyFragmentFunction = ShaderCore.library.makeFunction(name: "fragment_skybox")!
        let vertexDesc = MTKMetalVertexDescriptorFromModelIO(skyCube.vertexDescriptor)!
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = skyVertexFunction
        pipelineDescriptor.fragmentFunction = skyFragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        pipelineDescriptor.vertexDescriptor = vertexDesc
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .lessEqual
        depthDescriptor.isDepthWriteEnabled = true
        
        skyMesh = try MTKMesh(mesh: skyCube, device: ShaderCore.device)
        skyboxPipelineState = try ShaderCore.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        skyboxDepthStencilState = ShaderCore.device.makeDepthStencilState(descriptor: depthDescriptor)!
        
        if let textureReference {
            let textureLoader = MTKTextureLoader(device: ShaderCore.device)
            guard let mdlTexture = MDLTexture(cubeWithImagesNamed: [textureReference.name], bundle: textureReference.bundle) else {
                throw NSError()
            }
            let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [
                .origin: MTKTextureLoader.Origin.topLeft,
                .SRGB: false,
                .generateMipmaps: false
            ]
            skyTexture = try textureLoader.newTexture(texture: mdlTexture, options: textureLoaderOptions)
        } else {
            skyTexture = try Self.generateSkyTexture(dimensions: [256, 256], settings: skySettings)
        }
    }
    
    static func generateSkyTexture(dimensions: simd_int2, settings: SkySettings) throws -> MTLTexture {
        let mdlTextures = MDLSkyCubeTexture(
            name: "swifty-creatives-sky",
            channelEncoding: .float16,
            textureDimensions: dimensions,
            turbidity: settings.turbidity,
            sunElevation: settings.sunElevation,
            upperAtmosphereScattering: settings.upperAtmosphereScattering,
            groundAlbedo: settings.groundAlbedo
        )
        let textureLoader = MTKTextureLoader(device: ShaderCore.device)
        return try textureLoader.newTexture(texture: mdlTextures, options: nil)
    }
    
    func draw(encoder: SCEncoder) {
        encoder.setRenderPipelineState(skyboxPipelineState)
        encoder.setDepthStencilState(skyboxDepthStencilState)
        encoder.setVertexBuffer(
            skyMesh.vertexBuffers[0].buffer,
            offset: 0,
            index: 0
        )
        let submesh = skyMesh.submeshes[0]
        encoder.setFragmentTexture(skyTexture, index: FragmentTextureIndex.SkyBox.rawValue)
        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: submesh.indexCount,
            indexType: submesh.indexType,
            indexBuffer: submesh.indexBuffer.buffer,
            indexBufferOffset: 0
        )
    }
}

extension SkyBox {
    public class SkySettings {
        public var turbidity: Float = 0.1
        public var sunElevation: Float = 0.8
        public var upperAtmosphereScattering: Float = 0.9
        public var groundAlbedo: Float = 0.5
    }
    public struct TextureReference {
        public var name: String
        public var bundle: Bundle
        public init(name: String, bundle: Bundle) {
            self.name = name
            self.bundle = bundle
        }
    }
}
