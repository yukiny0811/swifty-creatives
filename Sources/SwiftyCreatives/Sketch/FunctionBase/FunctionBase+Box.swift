//
//  FunctionBase+Box.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import SimpleSimdSwift

public extension FunctionBase {
    
    func box(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        setUniforms(modelPos: f3(x, y, z), modelScale: f3(scaleX, scaleY, scaleZ), hasTexture: false)
        setVertices(BoxInfo.vertices)
        setUVs(BoxInfo.uvs)
        setNormals(BoxInfo.normals)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func box(_ scale: Float) {
        setUniforms(modelPos: .zero, modelScale: .one * scale, hasTexture: false)
        setVertices(BoxInfo.vertices)
        setUVs(BoxInfo.uvs)
        setNormals(BoxInfo.normals)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func box(_ pos: f3, _ scale: f3) {
        setUniforms(modelPos: pos, modelScale: scale, hasTexture: false)
        setVertices(BoxInfo.vertices)
        setUVs(BoxInfo.uvs)
        setNormals(BoxInfo.normals)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func box(_ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        setUniforms(modelPos: .zero, modelScale: f3(scaleX, scaleY, scaleZ), hasTexture: false)
        setVertices(BoxInfo.vertices)
        setUVs(BoxInfo.uvs)
        setNormals(BoxInfo.normals)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func box(_ scale: f3) {
        setUniforms(modelPos: .zero, modelScale: scale, hasTexture: false)
        setVertices(BoxInfo.vertices)
        setUVs(BoxInfo.uvs)
        setNormals(BoxInfo.normals)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
}
