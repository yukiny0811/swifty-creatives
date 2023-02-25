//
//  Sketch+Functions.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import simd
#if os(macOS)
import AppKit
#endif

public extension Sketch {
    
    func color(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        privateEncoder?.setVertexBytes([f4(r, g, b, a)], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
    }
    
    func box(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, scaleZ)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(BoxInfo.vertices, length: BoxInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(BoxInfo.uvs, length: BoxInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(BoxInfo.normals, length: BoxInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: BoxInfo.primitiveType, vertexStart: 0, vertexCount: BoxInfo.vertices.count)
    }
    
    func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
    
    func circle(_ x: Float, _ y: Float, _ z: Float, _ radX: Float, _ radY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(radX, radY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(CircleInfo.vertices, length: CircleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(CircleInfo.uvs, length: CircleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(CircleInfo.normals, length: CircleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawIndexedPrimitives(type: CircleInfo.primitiveType, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
    }
    
    func triangle(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float) {
        privateEncoder?.setVertexBytes([f3(x, y, z)], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3(scaleX, scaleY, 1)], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.vertices, length: TriangleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.uvs, length: TriangleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes(TriangleInfo.normals, length: TriangleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: TriangleInfo.primitiveType, vertexStart: 0, vertexCount: TriangleInfo.vertices.count)
    }
    
    func line(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        privateEncoder?.setVertexBytes([f3(x1, y1, z1), f3(x2, y2, z2)], length: f3.memorySize * 2, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.setVertexBytes([f2.zero, f2.zero], length: f2.memorySize * 2, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero], length: f3.memorySize * 2, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .line, vertexStart: 0, vertexCount: 2)
    }
    
    func boldline(_ x1: Float, _ y1: Float, _ z1: Float, _ x2: Float, _ y2: Float, _ z2: Float, width: Float) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue) // model pos
        privateEncoder?.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue) // model scale
        let diffY = y2 - y1
        let diffX = x2 - x1
        if diffX <= 0.00001 {
            let corner1 = f3(x1 - width, y1, z1)
            let corner2 = f3(x1 + width, y1, z1)
            let corner3 = f3(x2 - width, y2, z2)
            let corner4 = f3(x2 + width, y2, z2)
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
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
            privateEncoder?.setVertexBytes([corner1, corner2, corner3, corner4], length: f3.memorySize * 4, index: VertexBufferIndex.Position.rawValue)
        }
        privateEncoder?.setVertexBytes([f2.zero, f2.zero, f2.zero, f2.zero], length: f2.memorySize * 4, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBytes([f3.zero, f3.zero, f3.zero, f3.zero], length: f3.memorySize * 4, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setFragmentBytes([false], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        privateEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
    
    func translate(_ x: Float, _ y: Float, _ z: Float) {
        let translateMatrix = f4x4.createTransform(x, y, z)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * translateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotateX(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(1, 0, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotateY(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 1, 0))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotateZ(_ rad: Float) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: f3(0, 0, 1))
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func rotate(_ rad: Float, axis: f3) {
        let rotateMatrix = f4x4.createRotation(angle: rad, axis: axis)
        self.customMatrix[self.customMatrix.count - 1] = self.customMatrix[self.customMatrix.count - 1] * rotateMatrix
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func pushMatrix() {
        self.customMatrix.append(f4x4.createIdentity())
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func popMatrix() {
        let _ = self.customMatrix.popLast()
        privateEncoder?.setVertexBytes([self.customMatrix.reduce(f4x4.createIdentity(), *)], length: f4x4.memorySize, index: VertexBufferIndex.CustomMatrix.rawValue)
    }
    
    func setFog(color: f4, density: Float) {
        privateEncoder?.setFragmentBytes([density], length: Float.memorySize, index: FragmentBufferIndex.FogDensity.rawValue)
        privateEncoder?.setFragmentBytes([color], length: f4.memorySize, index: FragmentBufferIndex.FogColor.rawValue)
    }
    
    func drawHitTestableBox(box: HitTestableBox) {
        pushMatrix()
        
        pushMatrix()
        translate(0, 0, box.scale.z)
        box.front.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        translate(0, 0, -box.scale.z)
        box.back.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateY(Float.pi/2)
        translate(0, 0, box.scale.x)
        box.l.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateY(Float.pi/2)
        translate(0, 0, -box.scale.x)
        box.r.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateX(Float.pi/2)
        translate(0, 0, box.scale.y)
        box.top.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateX(Float.pi/2)
        translate(0, 0, -box.scale.y)
        box.bottom.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        popMatrix()
    }
    
    func drawNumberText<T: Numeric>(encoder: SCEncoder, factory: NumberTextFactory, number: T, spacing: Float = 1, scale: Float = 1) {
        let text = String(describing: number)
        drawGeneralText(encoder: encoder, factory: factory, text: text, spacing: spacing, scale: scale)
    }
    
    func drawGeneralText(encoder: SCEncoder, factory: TextFactory, text: String, spacing: Float = 1, scale: Float = 1, spacer: Float = 1) {
        encoder.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes([f4.one], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        pushMatrix()
        var totalLength: Float = 0
        for n in text {
            guard let data = factory.registeredTextures[String(n)] else {
                totalLength += spacer
                continue
            }
            totalLength += data.size.x * scale
            totalLength += spacing
        }
        totalLength -= spacing
        translate(-totalLength / 2, 0, 0)
        for n in text {
            guard let data = factory.registeredTextures[String(n)] else {
                translate(spacer, 0, 0)
                continue
            }
            encoder.setFragmentTexture(data.texture, index: FragmentTextureIndex.MainTexture.rawValue)
            encoder.setVertexBytes([data.size * scale], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
            encoder.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
            translate(data.size.x * scale, 0, 0)
            translate(spacing, 0, 0)
        }
        popMatrix()
    }
    
    #if os(macOS)
    func mousePos(event: NSEvent, viewFrame: NSRect) -> f2 {
        var location = event.locationInWindow
        location.y = event.window!.contentRect(forFrameRect: event.window!.frame).height - location.y
        location -= CGPoint(x: viewFrame.minX, y: viewFrame.minY)
        return f2(Float(location.x), Float(location.y))
    }
    #endif
}
