//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal
import simd

class Triangle {
//    static let shrinkScale: Float = 0.01
//    var vertexDatas: [Vertex] = []
//    var buffer: MTLBuffer
//    init(_ p1: SCPoint3, _ p2: SCPoint3, _ p3: SCPoint3) {
//        let color = SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
//        vertexDatas = [
//            Vertex(position: p1.shrink(Triangle.shrinkScale).simd, color: color),
//            Vertex(position: p2.shrink(Triangle.shrinkScale).simd, color: color),
//            Vertex(position: p3.shrink(Triangle.shrinkScale).simd, color: color)
//        ]
//        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
//    }
//    func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
//        for i in 0..<vertexDatas.count {
//            vertexDatas[i].color = simd_float4(r, g, b, a)
//        }
//        updateBuffer()
//    }
//    func draw(_ encoder: MTLRenderCommandEncoder) {
//        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
//        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexDatas.count)
//    }
//    func updateBuffer() {
//        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
//    }
}
