//
//  File.swift
//  SwiftyCreatives
//
//  Created by Yuki Kuwashima on 2024/09/21.
//

import MetalKit
import ModelIO
import Foundation
import SwiftyCreatives
import SwiftUI

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

struct Material: Equatable {

    static func == (lhs: Material, rhs: Material) -> Bool {
        lhs.diffuseTexture?.label == rhs.diffuseTexture?.label
    }
    
    var diffuseTexture: MTLTexture?
    var specularTexture: MTLTexture?

    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        self.diffuseTexture  = loadTexture(.baseColor, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.specularTexture = loadTexture(.specular,  mdlMaterial: mdlMaterial, textureLoader: textureLoader)
    }

    func loadTexture(_ semantic: MDLMaterialSemantic, mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else {
            return nil
        }
        switch materialProperty.type {
        case .string:
            guard let textureName = materialProperty.stringValue else {
                return nil
            }
            return try? textureLoader.newTexture(name: textureName, scaleFactor: 1, bundle: .main)
        default:
            return nil
        }
    }
}

class ModelObject: Equatable {

    static func == (lhs: ModelObject, rhs: ModelObject) -> Bool {
        lhs.meshes == rhs.meshes
    }

    var meshes = [Mesh]()

    func loadModel(url: URL, vertexDescriptor: MTLVertexDescriptor, textureLoader: MTKTextureLoader) {
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

        let bufferAllocator = MTKMeshBufferAllocator(device: ShaderUtils.device)
        let asset = MDLAsset(url: url, vertexDescriptor: modelVertexDescriptor, bufferAllocator: bufferAllocator)

        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: ShaderUtils.device) else {
            print("Failed to create meshes")
            return
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
    }

    func render(renderEncoder: MTLRenderCommandEncoder) {
        for mesh in self.meshes {
            // Bind vertex buffer
            let vertexBuffer = mesh.mesh.vertexBuffers[0]
            renderEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
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

public struct Model3D: ReactiveGraphicsEntity, HasCollider {

    public static func == (lhs: Model3D, rhs: Model3D) -> Bool {
        lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale && lhs.color == rhs.color
    }

    public var position: f3
    public var rotation: f3
    public var scale: f3
    public var color: f4
    public var collider: Collider
    public var rayInteractionEnabled = false
    public var hoverStatusChangeProcess: ((_ hoverStatus: Bool) -> ())?
    public var tapProcess: (() -> ())?
    @GraphicsState public var currentlyHovering = false

    @GraphicsState var model: ModelObject?
    var modelURL: URL

    public init(modelURL: URL, position: f3 = .zero, rotation: f3 = .zero, scale: f3 = .one, color: f4 = .one, currentlyHovering: Bool = false, collider: Collider) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.color = color
        self.collider = .box(xLength: scale.x, yLength: scale.y, zLength: scale.z)
        self.currentlyHovering = currentlyHovering
        self.modelURL = modelURL
        self.collider = collider
    }

    public var entity: some ReactiveGraphicsEntity {
        Empty()
    }

    public func customRender(
        functions: HasSketchFunctions.Type,
        encoder: MTLRenderCommandEncoder?,
        vertexDescriptor: MTLVertexDescriptor?,
        customMatrix: inout [f4x4],
        ray: (origin: f3, direction: f3)?
    ) {

        if model == nil, let vertexDescriptor {
            model = ModelObject()
            model?.loadModel(url: modelURL, vertexDescriptor: vertexDescriptor, textureLoader: ShaderUtils.textureLoader)
        }

        guard let encoder else {
            return
        }
        functions.color(encoder, color)
        model?.render(renderEncoder: encoder)
    }

    public func enableRayInteraction() -> Self {
        var modifiedSelf = self
        modifiedSelf.rayInteractionEnabled = true
        return modifiedSelf
    }

    public func disableRayInteraction() -> Self {
        var modifiedSelf = self
        modifiedSelf.rayInteractionEnabled = false
        return modifiedSelf
    }

    public func onTap(process: (() -> ())?) -> Self {
        var modifiedSelf = self
        modifiedSelf.tapProcess = process
        return modifiedSelf
    }

    public func hovering(_ currentlyHovering: GraphicsState<Bool>) -> Self {
        var modifiedSelf: Self = self
        modifiedSelf._currentlyHovering = currentlyHovering
        return modifiedSelf
    }

    public func setHovering(_ hovering: Bool) {
        currentlyHovering = hovering
    }
}
