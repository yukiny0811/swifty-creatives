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
        box(0, 0, 0, scale, scale, scale)
    }
    
    func box(_ pos: f3, _ scale: f3) {
        box(pos.x, pos.y, pos.z, scale.x, scale.y, scale.z)
    }
    
    func box(_ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        box(0, 0, 0, scaleX, scaleY, scaleZ)
    }
    
    func box(_ scale: f3) {
        box(0, 0, 0, scale.x, scale.y, scale.z)
    }
}
