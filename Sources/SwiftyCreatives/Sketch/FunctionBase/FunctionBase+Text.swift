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
        privateEncoder?.setVertexBuffer(text.posBuffer!, offset: 0, index: VertexBufferIndex.Position.rawValue)
        privateEncoder?.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: text.finalVertices.count)
    }
    
    func text(_ text: Text3D, primitiveType: MTLPrimitiveType = .triangle) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        privateEncoder?.setVertexBuffer(text.posBuffer!, offset: 0, index: VertexBufferIndex.Position.rawValue)
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
}