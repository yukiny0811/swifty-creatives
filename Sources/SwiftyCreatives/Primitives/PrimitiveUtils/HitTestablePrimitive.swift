//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

import simd

public class HitTestablePrimitive<Info: PrimitiveInfo>: Primitive<Info> {
    private func calculateHitTest(origin: f3, direction: f3) -> (x: f3, scaledPoint: f3, inversedX: f3)? {
        
        let model = mockModel()

        let a = model * f4(0, 0, 1, 1)

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
        
        let inverseModel = simd_inverse(model)
        let inversedXVector = inverseModel * f4(x.x, x.y, x.z, 1)
        let inversedX = f3(inversedXVector.x, inversedXVector.y, inversedXVector.z)
        
        let scaledPoint = self.scale
        
        guard -scaledPoint.x < inversedX.x && inversedX.x < scaledPoint.x &&
                -scaledPoint.y < inversedX.y && inversedX.y < scaledPoint.y else {
            return nil
        }
        
        return (x, scaledPoint, inversedX)
    }
    
    public func hitTestGetPos(origin: f3, direction: f3) -> f3? {
        if let result = calculateHitTest(origin: origin, direction: direction) {
            return result.x
        } else {
            return nil
        }
    }
    
    public func hitTestGetNormalizedCoord(origin: f3, direction: f3) -> f2? {
        if let result = calculateHitTest(origin: origin, direction: direction) {
            let inversedPointF2 = f2(result.inversedX.x / result.scaledPoint.x, result.inversedX.y / result.scaledPoint.y)
            return inversedPointF2
        } else {
            return nil
        }
    }
}
