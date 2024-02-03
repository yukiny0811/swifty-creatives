//
//  FunctionBase+Circle.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    
    func circle(_ x: Float, _ y: Float, _ z: Float, _ radX: Float, _ radY: Float) {
        setUniforms(modelPos: f3(x, y, z), modelScale: f3(radX, radY, 1), hasTexture: false)
        setVertices(CircleInfo.vertices)
        setUVs(CircleInfo.uvs)
        setNormals(CircleInfo.normals)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func circle(_ pos: f3, _ radX: Float, _ radY: Float) {
        setUniforms(modelPos: pos, modelScale: f3(radX, radY, 1), hasTexture: false)
        setVertices(CircleInfo.vertices)
        setUVs(CircleInfo.uvs)
        setNormals(CircleInfo.normals)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func circle(_ pos: f3, _ rad: Float) {
        setUniforms(modelPos: pos, modelScale: .init(rad, rad, 1), hasTexture: false)
        setVertices(CircleInfo.vertices)
        setUVs(CircleInfo.uvs)
        setNormals(CircleInfo.normals)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func circle(_ rad: Float) {
        setUniforms(modelPos: .zero, modelScale: .init(rad, rad, 1), hasTexture: false)
        setVertices(CircleInfo.vertices)
        setUVs(CircleInfo.uvs)
        setNormals(CircleInfo.normals)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func circle(_ radX: Float, _ radY: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(radX, radY, 1), hasTexture: false)
        setVertices(CircleInfo.vertices)
        setUVs(CircleInfo.uvs)
        setNormals(CircleInfo.normals)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
}
