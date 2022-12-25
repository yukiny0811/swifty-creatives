//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit

public struct ImgInfo: PrimitiveInfo {
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let bytes: [f3] = [
        VertexPoint.A,
        VertexPoint.B,
        VertexPoint.D,
        VertexPoint.C
    ]
    public static let vertexCount: Int = 4
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    public static var hasTexture: [Bool] = [true]
}

public class Img: Primitive<ImgInfo> {
    private var texture: MTLTexture?
    public func load(image: CGImage) {
        let loader = MTKTextureLoader(device: ShaderCore.device)
        let tex = try! loader.newTexture(cgImage: image)
        self.texture = tex
        let longer: Float = Float(max(image.width, image.height))
        self.setScale(
            f3(
                Float(image.width) / longer,
                Float(image.height) / longer,
                1
            )
        )
    }
    override public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBytes(ImgInfo.bytes, length: ImgInfo.vertexCount * f3.memorySize, index: 0)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 1)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 3)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 4)
        encoder.setVertexBytes(ImgInfo.hasTexture, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.setFragmentBytes(ImgInfo.hasTexture, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.setFragmentTexture(self.texture, index: 0)
        encoder.drawPrimitives(type: ImgInfo.primitiveType, vertexStart: 0, vertexCount: ImgInfo.vertexCount)
    }
}
