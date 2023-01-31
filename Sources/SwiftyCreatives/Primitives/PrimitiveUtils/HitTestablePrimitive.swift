//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

import GLKit

public class HitTestablePrimitive<Info: PrimitiveInfo>: Primitive<Info> {
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
