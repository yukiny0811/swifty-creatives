//
//  ModelObject.swift
//
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

import MetalKit
import ModelIO


public struct ModelObjectInfo: PrimitiveInfo {
    public static var vertices: [f3] = []
    public static var uvs: [f2] = []
    public static var normals: [f3] = []
    public static let vertexCount: Int = 0
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    public static let hasTexture: [Bool] = [true]
}

open class ModelObject: Primitive<ModelObjectInfo> {
    
    var mesh: [Any] = []
    var texture: MTLTexture?
    
    public func loadModelFromInternal(name: String, extensionName: String) {
        
        let allocator = MTKMeshBufferAllocator(device: ShaderCore.device)

        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.layouts = [
            MDLVertexBufferLayout(stride: 16),
            MDLVertexBufferLayout(stride: 8),
            MDLVertexBufferLayout(stride: 16)
        ]

        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition, format: MDLVertexFormat.float3, offset: 0, bufferIndex: VertexAttributeIndex.Position.rawValue),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: MDLVertexFormat.float2, offset: 0, bufferIndex: VertexAttributeIndex.UV.rawValue),
            MDLVertexAttribute(name: MDLVertexAttributeNormal, format: MDLVertexFormat.float3, offset: 0, bufferIndex: VertexAttributeIndex.Normal.rawValue)
        ]

        let asset = MDLAsset(
            url: Bundle.module.url(forResource: name, withExtension: extensionName)!,
            vertexDescriptor: vertexDescriptor,
            bufferAllocator: allocator
        )
        
        asset.loadTextures()

        mesh = try! MTKMesh.newMeshes(asset: asset, device: ShaderCore.device).metalKitMeshes
        
        let meshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh]
        guard let mdlMesh = meshes?.first else {
            fatalError("Did not find any meshes in the Model I/O asset")
        }
        
        let textureLoader = MTKTextureLoader(device: ShaderCore.device)
        let options: [MTKTextureLoader.Option : Any] = [
            .textureUsage : MTLTextureUsage.shaderRead.rawValue,
            .textureStorageMode : MTLStorageMode.private.rawValue,
            .origin : MTKTextureLoader.Origin.bottomLeft.rawValue
        ]
        
        for sub in mdlMesh.submeshes! as! [MDLSubmesh] {
            if let baseColorProperty = sub.material?.property(
                with: MDLMaterialSemantic.baseColor
            ) {
                if baseColorProperty.type == .texture, let textureURL = baseColorProperty.urlValue {
                    let tex = try? textureLoader.newTexture(
                        URL: textureURL,
                        options: options)
                    texture = tex
                }
            }
        }
    }
    
    public func loadModel(name: String, extensionName: String) {
        
        let allocator = MTKMeshBufferAllocator(device: ShaderCore.device)

        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.layouts = [
            MDLVertexBufferLayout(stride: 16),
            MDLVertexBufferLayout(stride: 8),
            MDLVertexBufferLayout(stride: 16)
        ]

        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition, format: MDLVertexFormat.float3, offset: 0, bufferIndex: VertexAttributeIndex.Position.rawValue),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: MDLVertexFormat.float2, offset: 0, bufferIndex: VertexAttributeIndex.UV.rawValue),
            MDLVertexAttribute(name: MDLVertexAttributeNormal, format: MDLVertexFormat.float3, offset: 0, bufferIndex: VertexAttributeIndex.Normal.rawValue)
        ]

        let asset = MDLAsset(
            url: Bundle.main.url(forResource: name, withExtension: extensionName)!,
            vertexDescriptor: vertexDescriptor,
            bufferAllocator: allocator
        )
        
        asset.loadTextures()

        mesh = try! MTKMesh.newMeshes(asset: asset, device: ShaderCore.device).metalKitMeshes
        
        let meshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh]
        guard let mdlMesh = meshes?.first else {
            fatalError("Did not find any meshes in the Model I/O asset")
        }
        
        let textureLoader = MTKTextureLoader(device: ShaderCore.device)
        let options: [MTKTextureLoader.Option : Any] = [
            .textureUsage : MTLTextureUsage.shaderRead.rawValue,
            .textureStorageMode : MTLStorageMode.private.rawValue,
            .origin : MTKTextureLoader.Origin.bottomLeft.rawValue
        ]
        
        for sub in mdlMesh.submeshes! as! [MDLSubmesh] {
            if let baseColorProperty = sub.material?.property(
                with: MDLMaterialSemantic.baseColor
            ) {
                if baseColorProperty.type == .texture, let textureURL = baseColorProperty.urlValue {
                    let tex = try? textureLoader.newTexture(
                        URL: textureURL,
                        options: options)
                    texture = tex
                }
            }
        }
    }
    override public func draw(_ encoder: SCEncoder) {
        
        guard let meshes = self.mesh as? [MTKMesh] else { return }
        
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        
        for mesh in meshes {
            
            for b in 0..<mesh.vertexBuffers.count {
                switch b {
                case 0:
                    encoder.setVertexBuffer(mesh.vertexBuffers[b].buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
                case 1:
                    encoder.setVertexBuffer(mesh.vertexBuffers[b].buffer, offset: 0, index: VertexBufferIndex.UV.rawValue)
                case 2:
                    encoder.setVertexBuffer(mesh.vertexBuffers[b].buffer, offset: 0, index: VertexBufferIndex.Normal.rawValue)
                default:
                    break
                }
            }
            for s in mesh.submeshes {
                encoder.setFragmentTexture(texture, index: FragmentTextureIndex.MainTexture.rawValue)
                encoder.drawIndexedPrimitives(type: s.primitiveType, indexCount: s.indexCount, indexType: s.indexType, indexBuffer: s.indexBuffer.buffer, indexBufferOffset: s.indexBuffer.offset)
            }
        }
    }
}
