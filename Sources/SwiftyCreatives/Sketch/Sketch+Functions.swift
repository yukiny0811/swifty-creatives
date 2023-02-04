//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import simd

public extension Sketch {
    
    func color(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        privateEncoder?.setVertexBytes([f4(r, g, b, a)], length: f4.memorySize, index: 10)
    }
    
    func box(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, scaleZ)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(BoxInfo.vertices, length: BoxInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(BoxInfo.uvs, length: BoxInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(BoxInfo.normals, length: BoxInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: MemoryLayout<Bool>.stride, index: 6)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(RectInfo.vertices, length: RectInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(RectInfo.uvs, length: RectInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(RectInfo.normals, length: RectInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: MemoryLayout<Bool>.stride, index: 6)
        privateEncoder?.drawPrimitives(type: RectInfo.primitiveType, vertexStart: 0, vertexCount: RectInfo.vertices.count)
    }
    
    func circle(_ x: Float, _ y: Float, _ z: Float, _ radX: Float, _ radY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(radX, radY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(CircleInfo.vertices, length: CircleInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(CircleInfo.uvs, length: CircleInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(CircleInfo.normals, length: CircleInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: MemoryLayout<Bool>.stride, index: 6)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: MemoryLayout<Bool>.stride, index: 6)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func translate(_ x: Float, _ y: Float, _ z: Float) {
        let translateMatrix = f4x4.createTransform(x, y, z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * translateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func rotateX(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(1, 0, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func rotateY(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 1, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func rotateZ(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 0, 1))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func rotate(_ rad: Float, axis: f3) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: axis)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func pushMatrix() {
        self.customMatrix.append(f4x4.createIdentity())
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
    
    func popMatrix() {
        let _ = self.customMatrix.popLast()
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: 15)
    }
}
