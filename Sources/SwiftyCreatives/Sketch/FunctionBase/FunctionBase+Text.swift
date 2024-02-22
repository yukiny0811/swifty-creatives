//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/06/29.
//

import SimpleSimdSwift
import Metal

public extension FunctionBase {
    
    func text(_ text: Text2D, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        guard let textPosBuffer = text.posBuffer else { return }
        privateEncoder?.setVertexBuffer(textPosBuffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        let tempUVBuf = ShaderCore.device.makeBuffer(length: textPosBuffer.length * 2 / 3)
        let tempNormalBuf = ShaderCore.device.makeBuffer(length: textPosBuffer.length)
        let tempVertexColorBuf = ShaderCore.device.makeBuffer(length: textPosBuffer.length * 4 / 3)
        privateEncoder?.setVertexBuffer(tempUVBuf, offset: 0, index: VertexBufferIndex.UV.rawValue)
        privateEncoder?.setVertexBuffer(tempNormalBuf, offset: 0, index: VertexBufferIndex.Normal.rawValue)
        privateEncoder?.setVertexBuffer(tempVertexColorBuf, offset: 0, index: VertexBufferIndex.VertexColor.rawValue)
        privateEncoder?.setVertexBuffer(textPosBuffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: text.finalVertices.count)
    }
    
    func text(_ text: Text3D, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        guard let textPosBuffer = text.posBuffer else { return }
        privateEncoder?.setVertexBuffer(textPosBuffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: text.finalVertices.count)
    }
    
    func char(
        _ character: Character,
        factory: TextFactory,
        primitiveType: MTLPrimitiveType = .triangle,
        applyOffsetBefore: ((f2) -> ())? = nil,
        applySizeAfter: ((f2) -> ())? = nil
    ) {
        if let cached = factory.cached[character] {
            applyOffsetBefore?(cached.offset)
            setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
            privateEncoder?.setVertexBuffer(cached.buffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
            privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: cached.verticeCount)
            applySizeAfter?(cached.size)
        } else {
            print("no caches for \(character)")
        }
    }
    
    func text(_ str: String, factory: TextFactory) {
        var spacerFactor: Float = 0
        for c in str {
            if c == " " {
                translate(spacerFactor, 0, 0)
                continue
            }
            char(c, factory: factory) { [self] offset in
                translate(-offset.x, 0, 0)
                push {
                    translate(0, -offset.y, 0)
                }
            } applySizeAfter: { [self] size in
                translate(-size.x, 0, 0)
                spacerFactor = -size.x
            }
        }
    }
    
    func text(_ text: Text2D, topLeft: f4, topRight: f4, bottomLeft: f4, bottomRight: f4, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false, useVertexColor: true)
        guard let textPosBuffer = text.posBuffer else { return }
        let colors: [f4] = text.finalVerticesNormalized.map { pos in
            let xTopColor = mix(topLeft, topRight, t: pos.x)
            let xBottomColor = mix(bottomLeft, bottomRight, t: pos.x)
            let yColor = mix(xTopColor, xBottomColor, t: pos.y)
            return yColor
        }
        guard let vertexColorBuffer = ShaderCore.device.makeBuffer(bytes: colors, length: colors.count * f4.memorySize) else {
            return
        }
        privateEncoder?.setVertexBuffer(vertexColorBuffer, offset: 0, index: VertexBufferIndex.VertexColor.rawValue)
        privateEncoder?.setVertexBuffer(textPosBuffer, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: text.finalVertices.count)
    }
}
