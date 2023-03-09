//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd

public extension FunctionBase {
    func drawNumberText<T: Numeric>(encoder: SCEncoder, factory: NumberTextFactory, number: T, spacing: Float = 1, scale: Float = 1) {
        let text = String(describing: number)
        drawGeneralText(encoder: encoder, factory: factory, text: text, spacing: spacing, scale: scale)
    }
    
    func drawGeneralText(encoder: SCEncoder, factory: TextFactory, text: String, spacing: Float = 1, scale: Float = 1, spacer: Float = 1, color: f4 = .one) {
        encoder.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes([f3.one], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes([f4.one], length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        pushMatrix()
        var totalLength: Float = 0
        for (i, n) in text.enumerated() {
            guard let data = factory.registeredTextures[String(n)] else {
                totalLength += spacer
                continue
            }
            totalLength += data.size.x * scale
            if i != text.count - 1 {
                totalLength += spacing
            }
        }
        totalLength -= spacing
        translate(-totalLength / 2, 0, 0)
        for (i, n) in text.enumerated() {
            guard let data = factory.registeredTextures[String(n)] else {
                translate(spacer, 0, 0)
                continue
            }
            let coloredTexture = data.texture
            textPostProcessor.postProcessColor(originalTexture: data.texture, texture: coloredTexture, color: color)
            encoder.setFragmentTexture(coloredTexture, index: FragmentTextureIndex.MainTexture.rawValue)
            encoder.setVertexBytes([data.size * scale], length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
            encoder.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
            translate(data.size.x * scale, 0, 0)
            if i != text.count - 1 {
                translate(spacing, 0, 0)
            }
        }
        popMatrix()
    }
}
