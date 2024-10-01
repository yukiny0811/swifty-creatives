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
    public func loadModel(name: String, extensionName: String, bundle: Bundle = .main) -> Self {
        
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
            url: bundle.url(forResource: name, withExtension: extensionName)!,
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
                    #if os(iOS) || os(visionOS) || os(tvOS)
                    let tex = try? textureLoader.newTexture(cgImage: UIImage(named: baseColorProperty.stringValue!)!.cgImage!)
                    #elseif os(macOS)
                    let image = bundle.image(forResource: baseColorProperty.stringValue!)!
                    let tex = try? textureLoader.newTexture(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
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
    
    public func draw(_ encoder: SCEncoder, with image: CGImage) {
            
        let loader = MTKTextureLoader(device: ShaderCore.device)
        let mtlTexture = try! loader.newTexture(cgImage: image)
        
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
                encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                encoder.setFragmentTexture(mtlTexture, index: FragmentTextureIndex.MainTexture.rawValue)
                encoder.drawIndexedPrimitives(type: s.primitiveType, indexCount: s.indexCount, indexType: s.indexType, indexBuffer: s.indexBuffer.buffer, indexBufferOffset: s.indexBuffer.offset)
            }
        }
    }
    
    public func draw(_ encoder: SCEncoder, with mtlTexture: MTLTexture) {
        
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
                encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
                encoder.setFragmentTexture(mtlTexture, index: FragmentTextureIndex.MainTexture.rawValue)
                encoder.drawIndexedPrimitives(type: s.primitiveType, indexCount: s.indexCount, indexType: s.indexType, indexBuffer: s.indexBuffer.buffer, indexBufferOffset: s.indexBuffer.offset)
            }
        }
    }
}

class Mesh: Equatable {

    static func == (lhs: Mesh, rhs: Mesh) -> Bool {
        lhs.mesh == rhs.mesh
    }

    var mesh: MTKMesh
    var materials: [Material]
    init(mesh: MTKMesh, materials: [Material]) {
        self.mesh = mesh
        self.materials = materials
    }
}

public struct Material: Equatable {

    public static func == (lhs: Material, rhs: Material) -> Bool {
        lhs.diffuseTexture?.label == rhs.diffuseTexture?.label
    }

    var diffuseTexture: MTLTexture?
    var specularTexture: MTLTexture?

    public init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        self.diffuseTexture = loadTexture(.baseColor, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.specularTexture = loadTexture(.specular,  mdlMaterial: mdlMaterial, textureLoader: textureLoader)
    }

    public func loadTexture(_ semantic: MDLMaterialSemantic, mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else {
            print("no material property \(semantic)")
            return nil
        }
        switch materialProperty.type {
        case .string:
            guard let textureName = materialProperty.stringValue else {
                print("no texture")
                return nil
            }
            return try? textureLoader.newTexture(name: textureName, scaleFactor: 1, bundle: .main)
        case .texture:
            guard let tex = materialProperty.textureSamplerValue?.texture else {
                print("not texture sample value")
                return nil
            }
            return try? ShaderCore.textureLoader.newTexture(texture: tex)
        default:
            //            print(String(describing: materialProperty.type))
            return nil
        }
    }
}

public class ModelObject3D: Equatable {
    
    public static func == (lhs: ModelObject3D, rhs: ModelObject3D) -> Bool {
        lhs.meshes == rhs.meshes
    }
    
    var meshes = [Mesh]()
    
    public init() {}

    public func loadModel(url: URL, vertexDescriptor: MTLVertexDescriptor, textureLoader: MTKTextureLoader) -> Self {
        let modelVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)

        let attrPosition = modelVertexDescriptor.attributes[0] as! MDLVertexAttribute
        attrPosition.name = MDLVertexAttributePosition
        modelVertexDescriptor.attributes[0] = attrPosition

        let attrTexCoord = modelVertexDescriptor.attributes[1] as! MDLVertexAttribute
        attrTexCoord.name = MDLVertexAttributeTextureCoordinate
        modelVertexDescriptor.attributes[1] = attrTexCoord

        let attrNormal = modelVertexDescriptor.attributes[2] as! MDLVertexAttribute
        attrNormal.name = MDLVertexAttributeNormal
        modelVertexDescriptor.attributes[2] = attrNormal

        let attrColor = modelVertexDescriptor.attributes[3] as! MDLVertexAttribute
        attrColor.name = MDLVertexAttributeColor
        modelVertexDescriptor.attributes[3] = attrColor

        let bufferAllocator = MTKMeshBufferAllocator(device: ShaderCore.device)
        let asset = MDLAsset(url: url, vertexDescriptor: modelVertexDescriptor, bufferAllocator: bufferAllocator)

        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: ShaderCore.device) else {
            print("Failed to create meshes")
            return self
        }

        self.meshes.reserveCapacity(mdlMeshes.count)

        // Create our meshes
        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            var materials = [Material]()
            for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
                let material = Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader)
                materials.append(material)
            }
            let mesh = Mesh(mesh: mtkMesh, materials: materials)
            self.meshes.append(mesh)
        }

        return self
    }

    public func render(renderEncoder: MTLRenderCommandEncoder, pos: f3, rot: f3, scale: f3) {
        renderEncoder.setVertexBytes([pos], length: f3.memorySize, index: 16)
        renderEncoder.setVertexBytes([rot], length: f3.memorySize, index: 17)
        renderEncoder.setVertexBytes([scale], length: f3.memorySize, index: 18)
        for mesh in self.meshes {

            for b in 0..<mesh.mesh.vertexBuffers.count {
                switch b {
                case 0:
                    renderEncoder.setVertexBuffer(mesh.mesh.vertexBuffers[b].buffer, offset: 0, index: 0)
                case 1:
                    renderEncoder.setVertexBuffer(mesh.mesh.vertexBuffers[b].buffer, offset: 0, index: 11)
                case 2:
                    renderEncoder.setVertexBuffer(mesh.mesh.vertexBuffers[b].buffer, offset: 0, index: 12)
                case 3:
                    renderEncoder.setVertexBuffer(mesh.mesh.vertexBuffers[b].buffer, offset: 0, index: 19)
                default:
                    break
                }
            }

            // Bind vertex buffer
//            let vertexBuffer = mesh.mesh.vertexBuffers[0]
//            renderEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            for (submesh, material) in zip(mesh.mesh.submeshes, mesh.materials) {
                // Bind textures
                renderEncoder.setFragmentTexture(material.diffuseTexture, index: 1)
                renderEncoder.setFragmentTexture(material.specularTexture, index: 2)

                // Draw
                let indexBuffer = submesh.indexBuffer
                renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: indexBuffer.buffer, indexBufferOffset: 0)
            }
        }
    }
}
