//
//  Sketch+Functions.swift
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
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(RectInfo.vertices, length: RectInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(RectInfo.uvs, length: RectInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(RectInfo.normals, length: RectInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawPrimitives(type: RectInfo.primitiveType, vertexStart: 0, vertexCount: RectInfo.vertices.count)
    }
    
    func circle(_ x: Float, _ y: Float, _ z: Float, _ radX: Float, _ radY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(radX, radY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(CircleInfo.vertices, length: CircleInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(CircleInfo.uvs, length: CircleInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(CircleInfo.normals, length: CircleInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: 0)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: 11)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: 12)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func line(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: 1)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: 3)
        privateEncoder?.setVertexBytes([f3(x1, y1, z1), f3(x2, y2, z2)], length: f3.memorySize * 2, index: 0)
        privateEncoder?.setVertexBytes([f2.zero, f2.zero], length: f2.memorySize * 2, index: 11)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero], length: f3.memorySize * 2, index: 12)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
    
    func boldline(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float, width: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: 1) // model pos
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: 3) // model scale
        let diffY = y2 - y1
        let diffX = x2 - x1
        if diffX <= 0.00001 {
            let corner1 = f3(x1 - width, y1, z1)
            let corner2 = f3(x1 + width, y1, z1)
            let corner3 = f3(x2 - width, y2, z2)
            let corner4 = f3(x2 + width, y2, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: 0)
        } else {
            let a_xy = diffY / diffX
            let inv_a = 1 / a_xy
            let rad = atan2(1, inv_a)
            let yValue = sin(rad) * width
            let xValue = cos(rad) * width
            let corner1 = f3(x1 - xValue, y1 + yValue, z1)
            let corner2 = f3(x1 + xValue, y1 - yValue, z1)
            let corner3 = f3(x2 - xValue, y2 + yValue, z2)
            let corner4 = f3(x2 + xValue, y2 - yValue, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: 0)
        }
        privateEncoder?.setVertexBytes([f2.zero, f2.zero, f2.zero, f2.zero], length: f2.memorySize * 4, index: 11)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero, f3.zero, f3.zero], length: f3.memorySize * 4, index: 12)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: 6)
        privateEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
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
    
    func setFog(color: f4, density: Float) {
        privateEncoder?.setFragmentBytes([density], length: Float.memorySize, index: 16)
        privateEncoder?.setFragmentBytes([color], length: f4.memorySize, index: 17)
    }
}
