//
//  Circ.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import Metal

public struct CircleInfo: PrimitiveInfo {
    private static let edgeCount: Float = 30.0
    private static let portion: Float = Float.pi * 2 / Self.edgeCount
    public static var vertices: [f3] = [
        f3(cos(portion * 0 ), sin(portion * 0), 0),
        f3( cos(portion*1), sin(portion*1), 0 ),
        f3( cos(portion*2), sin(portion*2), 0 ),
        f3( cos(portion*3), sin(portion*3), 0 ),
        f3( cos(portion*4), sin(portion*4), 0 ),
        f3( cos(portion*5), sin(portion*5), 0 ),
        f3( cos(portion*6), sin(portion*6), 0 ),
        f3( cos(portion*7), sin(portion*7), 0 ),
        f3( cos(portion*8), sin(portion*8), 0 ),
        f3( cos(portion*9), sin(portion*9), 0 ),

        f3( cos(portion*10), sin(portion*10), 0 ),
        f3( cos(portion*11), sin(portion*11), 0 ),
        f3( cos(portion*12), sin(portion*12), 0 ),
        f3( cos(portion*13), sin(portion*13), 0 ),
        f3( cos(portion*14), sin(portion*14), 0 ),
        f3( cos(portion*15), sin(portion*15), 0 ),
        f3( cos(portion*16), sin(portion*16), 0 ),
        f3( cos(portion*17), sin(portion*17), 0 ),
        f3( cos(portion*18), sin(portion*18), 0 ),
        f3( cos(portion*19), sin(portion*19), 0 ),

        f3( cos(portion*20), sin(portion*20), 0 ),
        f3( cos(portion*21), sin(portion*21), 0 ),
        f3( cos(portion*22), sin(portion*22), 0 ),
        f3( cos(portion*23), sin(portion*23), 0 ),
        f3( cos(portion*24), sin(portion*24), 0 ),
        f3( cos(portion*25), sin(portion*25), 0 ),
        f3( cos(portion*26), sin(portion*26), 0 ),
        f3( cos(portion*27), sin(portion*27), 0 ),
        f3( cos(portion*28), sin(portion*28), 0 ),
        f3( cos(portion*29), sin(portion*29), 0 )
    ]
    
    public static var uvs: [f2] = [
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero,
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero,
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero,
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero,
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero,
        f2.zero, f2.zero, f2.zero, f2.zero, f2.zero
    ]
    
    public static var normals: [f3] = [
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1),
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1),
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1),
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1),
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1),
        f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1), f3(0, 0, 1)
    ]
    public static let primitiveType: MTLPrimitiveType = .triangle
    
    public static let indexBuffer: MTLBuffer = ShaderCore.device.makeBuffer(bytes: Array<UInt16>([
    0, 1, 2,
    0, 2, 3,
    0, 3, 4,
    0, 4, 5,
    0, 5, 6,
    0, 6, 7,
    0, 7, 8,
    0, 8, 9,
    0, 9, 10,
    0, 10, 11,
    0, 11, 12,
    0, 12, 13,
    0, 13, 14,
    0, 14, 15,
    0, 15, 16,
    0, 16, 17,
    0, 17, 18,
    0, 18, 19,
    0, 19, 20,
    0, 20, 21,
    0, 21, 22,
    0, 22, 23,
    0, 23, 24,
    0, 24, 25,
    0, 25, 26,
    0, 26, 27,
    0, 27, 28,
    0, 28, 29,
    
    ]), length: 28 * 3 * UInt16.memorySize)!
}

open class Circ: Primitive<CircleInfo> {
    
    public required init() {
        super.init()
    }
    
    public override func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(CircleInfo.vertices, length: CircleInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(CircleInfo.uvs, length: CircleInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(CircleInfo.normals, length: CircleInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes(_material, length: Material.memorySize, index: FragmentBufferIndex.Material.rawValue)
        encoder.setFragmentBytes(self.hasTexture, length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentBytes(self.isActiveToLight, length: Bool.memorySize, index: FragmentBufferIndex.IsActiveToLight.rawValue)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: 28 * 3, indexType: .uint16, indexBuffer:CircleInfo.indexBuffer, indexBufferOffset: 0)
        
    }
}
