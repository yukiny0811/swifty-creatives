//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

import Metal
import GLKit

public struct RectInfo: PrimitiveInfo {
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}

public class Rect: Primitive<RectInfo> {
    
    public required init() {
        super.init()
        bytes = [
            Vertex(position: ImgInfo.VertexPoint.A, color: f4.zero, uv: f2(0, 0), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.B, color: f4.zero, uv: f2(0, 1), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.D, color: f4.zero, uv: f2(1, 0), normal: f3(0, 0, 1)),
            Vertex(position: ImgInfo.VertexPoint.C, color: f4.zero, uv: f2(1, 1), normal: f3(0, 0, 1))
        ]
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
