//
//  Img.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit

public struct ImgInfo: PrimitiveInfo {
    public static var vertices: [f3] = [
        Self.VertexPoint.A,
        Self.VertexPoint.B,
        Self.VertexPoint.D,
        Self.VertexPoint.C
    ]
    
    public static var uvs: [f2] = [
        f2(0, 0),
        f2(0, 1),
        f2(1, 0),
        f2(1, 1)
    ]
    
    public static var normals: [f3] = [
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1)
    ]
    
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}

open class Img: RectanglePlanePrimitive<ImgInfo> {
    
    public required init() {
        super.init()
        hasTexture = [true]
    }
    
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
    override public func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(ImgInfo.vertices, length: ImgInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(ImgInfo.uvs, length: ImgInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(ImgInfo.normals, length: ImgInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentTexture(self.texture, index: FragmentTextureIndex.MainTexture.rawValue)
        encoder.drawPrimitives(type: ImgInfo.primitiveType, vertexStart: 0, vertexCount: ImgInfo.vertices.count)
    }
}
