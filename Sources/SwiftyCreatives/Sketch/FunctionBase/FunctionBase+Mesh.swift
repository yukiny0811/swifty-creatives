//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/29.
//

import SimpleSimdSwift
import Metal

public extension FunctionBase {
    func mesh(_ vertices: [f3], primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        setVertices(vertices)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
    
    @available(*, deprecated, message: "use other mesh()")
    func mesh(_ buffer: MTLBuffer, count: Int, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        privateEncoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: count)
    }
    
    func mesh(_ buffer: MTLBuffer, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        privateEncoder?.setVertexBuffer(buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: buffer.length / f3.memorySize)
    }
    
    func mesh(vertices: [f3], uvs: [f2], normals: [f3], texture: MTLTexture) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: true)
        setVertices(vertices)
        setUVs(uvs)
        setNormals(normals)
        setTexture(texture)
        privateEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
    
    func mesh(vertices: MTLBuffer, uvs: MTLBuffer, normals: MTLBuffer, image: CGImage) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: true)
        privateEncoder?.setVertexBuffer(vertices, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBuffer(uvs, offset: 0, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBuffer(normals, offset: 0, index: VertexBufferIndex.Normal.rawValue)
        let loader = MTKTextureLoader(device: ShaderCore.device)
        if let mtlTexture = try? loader.newTexture(cgImage: image) {
            setTexture(mtlTexture)
        }
        privateEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.length / f3.memorySize)
    }
}
