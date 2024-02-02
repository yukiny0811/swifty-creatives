//
//  ModelObject.swift
//
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

import MetalKit
import ModelIO
import SimpleSimdSwift

open class ModelObject: Primitive<ModelObjectInfo> {
    
    public override init() {}
    
    var mesh: [Any] = []
    var texture: MTLTexture?
    
    @discardableResult
    public func loadModel(name: String, extensionName: String) -> Self {
        
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
            return self
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
                } else if baseColorProperty.type == .string {
                    #if os(iOS) || os(visionOS)
                    let tex = try? textureLoader.newTexture(cgImage: UIImage(named: baseColorProperty.stringValue!)!.cgImage!)
                    #elseif os(macOS)
                    let tex = try? textureLoader.newTexture(cgImage: NSImage(named: baseColorProperty.stringValue!)!.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
                    #endif
                    texture = tex
                }
            }
        }
        return self
    }
    public func setTexture(_ tex: MTLTexture) {
        self.texture = tex
    }
    override public func draw(_ encoder: SCEncoder) {
        
        guard let meshes = self.mesh as? [MTKMesh] else { return }
        
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        
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
                if texture != nil {
                    encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                    encoder.setFragmentTexture(texture, index: FragmentTextureIndex.MainTexture.rawValue)
                } else {
                    encoder.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                }
                encoder.drawIndexedPrimitives(type: s.primitiveType, indexCount: s.indexCount, indexType: s.indexType, indexBuffer: s.indexBuffer.buffer, indexBufferOffset: s.indexBuffer.offset)
            }
        }
    }
    
    public func draw(_ encoder: SCEncoder, primitiveType: MTLPrimitiveType) {
        
        guard let meshes = self.mesh as? [MTKMesh] else { return }
        
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        
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
                if texture != nil {
                    encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                    encoder.setFragmentTexture(texture, index: FragmentTextureIndex.MainTexture.rawValue)
                } else {
                    encoder.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                }
                encoder.drawIndexedPrimitives(type: primitiveType, indexCount: s.indexCount, indexType: s.indexType, indexBuffer: s.indexBuffer.buffer, indexBufferOffset: s.indexBuffer.offset)
            }
        }
    }
}
