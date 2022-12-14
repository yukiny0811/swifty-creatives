//
//  Triangle.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal

public class Triangle {
    private static let shrinkScale: Float = 0.01
    private final class VertexPoint {
        static let A: f3 = f3(x: 0, y: 1.0, z: 0.0)
        static let B: f3 = f3(x: -cos(Float.pi), y: -sin(Float.pi), z: 0.0)
        static let C: f3 = f3(x: cos(Float.pi), y: -sin(Float.pi), z: 0.0)
    }
    private var vertexDatas: [Vertex] = []
    private var buffer: MTLBuffer
    private var pos: f3
    private var rot: f3
    private var scale: f3
    public init(pos: f3) {
        self.pos = pos
        self.rot = f3.zero
        self.scale = f3.one
        let modelPos = self.pos * Triangle.shrinkScale
        vertexDatas = [
            Vertex(position: VertexPoint.A, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.B, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: f4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale)
        ]
        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        let simdColor = f4(r, g, b, a)
        vertexDatas[0].color = simdColor
        vertexDatas[1].color = simdColor
        vertexDatas[2].color = simdColor
        updateBuffer()
    }
    public func setPosition(_ p: f3) {
        self.pos = p * Triangle.shrinkScale
        vertexDatas[0].modelPos = self.pos
        vertexDatas[1].modelPos = self.pos
        vertexDatas[2].modelPos = self.pos
        updateBuffer()
    }
    public func setScale(_ s: f3) {
        self.scale = s
        vertexDatas[0].modelScale = s
        vertexDatas[1].modelScale = s
        vertexDatas[2].modelScale = s
        updateBuffer()
    }
    public func setRotation(_ r: f3) {
        self.rot = r
        vertexDatas[0].modelRot = r
        vertexDatas[1].modelRot = r
        vertexDatas[2].modelRot = r
        updateBuffer()
    }
    public func getScale() -> f3 {
        return scale
    }
    public func getRotation() -> f3 {
        return rot
    }
    public func getPosition() -> f3 {
        return pos
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexDatas.count)
    }
    private func updateBuffer() {
        buffer.contents().copyMemory(from: vertexDatas, byteCount: Vertex.memorySize * vertexDatas.count)
    }
}
