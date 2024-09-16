//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/29.
//

import SimpleSimdSwift
import Metal

public extension HasSketchFunctions {
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, _ vertices: [f3], primitiveType: MTLPrimitiveType = .triangle) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        Self.setVertices(encoder, vertices)
        encoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
    
    @available(*, deprecated, message: "use other mesh()")
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, _ buffer: MTLBuffer, count: Int, primitiveType: MTLPrimitiveType = .triangle) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        encoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: count)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, _ buffer: MTLBuffer, primitiveType: MTLPrimitiveType = .triangle) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false)
        encoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: buffer.length / f3.memorySize)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: [f3], uvs: [f2], normals: [f3], texture: MTLTexture) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: true)
        Self.setVertices(encoder, vertices)
        Self.setUVs(encoder, uvs)
        Self.setNormals(encoder, normals)
        Self.setTexture(encoder, texture)
        encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: [f3], uvs: [f2], normals: [f3], image: CGImage) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: true)
        Self.setVertices(encoder, vertices)
        Self.setUVs(encoder, uvs)
        Self.setNormals(encoder, normals)
        let loader = MTKTextureLoader(device: ShaderCore.device)
        if let mtlTexture = try? loader.newTexture(cgImage: image) {
            Self.setTexture(encoder, mtlTexture)
        }
        encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: MTLBuffer, uvs: MTLBuffer, normals: MTLBuffer, texture: MTLTexture) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: true)
        encoder?.setVertexBuffer(vertices, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder?.setVertexBuffer(uvs, offset: 0, index: VertexBufferIndex.UV.rawValue)
        encoder?.setVertexBuffer(normals, offset: 0, index: VertexBufferIndex.Normal.rawValue)
        Self.setTexture(encoder, texture)
        encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.length / f3.memorySize)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: MTLBuffer, uvs: MTLBuffer, normals: MTLBuffer, image: CGImage) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: true)
        encoder?.setVertexBuffer(vertices, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder?.setVertexBuffer(uvs, offset: 0, index: VertexBufferIndex.UV.rawValue)
        encoder?.setVertexBuffer(normals, offset: 0, index: VertexBufferIndex.Normal.rawValue)
        let loader = MTKTextureLoader(device: ShaderCore.device)
        if let mtlTexture = try? loader.newTexture(cgImage: image) {
            Self.setTexture(encoder, mtlTexture)
        }
        encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.length / f3.memorySize)
    }
    
    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: [f3], colors: [f4], primitiveType: MTLPrimitiveType) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false, useVertexColor: true)
        Self.setVertices(encoder, vertices)
        Self.setVertexColors(encoder, colors)
        encoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }

    @DrawFunction
    static func mesh(_ encoder: MTLRenderCommandEncoder?, vertices: MTLBuffer, colors: MTLBuffer, primitiveType: MTLPrimitiveType) {
        Self.setUniforms(encoder, modelPos: .zero, modelScale: .one, hasTexture: false, useVertexColor: true)
        encoder?.setVertexBuffer(vertices, offset: 0, index: VertexBufferIndex.Position.rawValue)
        encoder?.setVertexBuffer(colors, offset: 0, index: VertexBufferIndex.VertexColor.rawValue)
        encoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.length / f3.memorySize)
    }
}
