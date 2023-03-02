//
//  Sketch+Functions.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import simd

public extension Sketch {
    
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
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        
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
}
