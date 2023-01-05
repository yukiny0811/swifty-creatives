//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit
import GLKit

public struct ImgInfo: PrimitiveInfo {
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}

public class Img: Primitive<ImgInfo> {
    
    public required init() {
        super.init()
        hasTexture = [true]
        bytes = [
            Vertex(position: ImgInfo.VertexPoint.A, color: f4.zero, uv: f2(0, 0), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.B, color: f4.zero, uv: f2(0, 1), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.D, color: f4.zero, uv: f2(1, 0), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.C, color: f4.zero, uv: f2(1, 1), normal: f3(0, 0, 1))
        ]
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
    override public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBytes(self.bytes, length: self.bytes.count * Vertex.memorySize, index: 0)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 1)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 3)
        encoder.setFragmentBytes(_material, length: Material.memorySize, index: 1)
        encoder.setFragmentBytes(self.hasTexture, length: MemoryLayout<Bool>.stride, index: 6)
        encoder.setFragmentBytes(self.isActiveToLight, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.setFragmentTexture(self.texture, index: 0)
        encoder.drawPrimitives(type: ImgInfo.primitiveType, vertexStart: 0, vertexCount: self.bytes.count)
    }
    
    public func hitTestGetPos(origin: f3, direction: f3) -> f3? {
        let model = mockModel()

        let a = GLKMatrix4MultiplyVector4(model, GLKVector4(v: (0, 0, 1, 1)))

        let A = origin
        let B = origin + direction * 3000
        let n = simd_normalize(f3(a.x, a.y, a.z) - self.pos)
        let P = self.pos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        let inverseModel = GLKMatrix4Invert(model, nil)
        let inversedXVector = GLKMatrix4MultiplyVector4(inverseModel, GLKVector4(v: (x.x, x.y, x.z, 1)))
        let inversedX = f3(inversedXVector.x, inversedXVector.y, inversedXVector.z)
        
        let scaledPoint = self.scale
        
        guard -scaledPoint.x < inversedX.x && inversedX.x < scaledPoint.x &&
                -scaledPoint.y < inversedX.y && inversedX.y < scaledPoint.y else {
            return nil
        }
        
        return x
    }
    
    public func hitTestGetNormalizedCoord(origin: f3, direction: f3) -> f2? {
        let model = mockModel()

        let a = GLKMatrix4MultiplyVector4(model, GLKVector4(v: (0, 0, 1, 1)))

        let A = origin
        let B = origin + direction * 3000
        let n = simd_normalize(f3(a.x, a.y, a.z) - self.pos)
        let P = self.pos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        let inverseModel = GLKMatrix4Invert(model, nil)
        let inversedXVector = GLKMatrix4MultiplyVector4(inverseModel, GLKVector4(v: (x.x, x.y, x.z, 1)))
        let inversedX = f3(inversedXVector.x, inversedXVector.y, inversedXVector.z)
        
        let scaledPoint = self.scale
        
        guard -scaledPoint.x < inversedX.x && inversedX.x < scaledPoint.x &&
                -scaledPoint.y < inversedX.y && inversedX.y < scaledPoint.y else {
            return nil
        }
        
        let inversedPointF2 = f2(inversedX.x / scaledPoint.x, inversedX.y / scaledPoint.y)
        
        return inversedPointF2
    }
}
