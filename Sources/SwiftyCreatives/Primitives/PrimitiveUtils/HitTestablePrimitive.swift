//
//  HitTestablePrimitive.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

import simd

public class HitTestablePrimitive<Info: PrimitiveInfo>: Primitive<Info> {
    public func calculateHitTest(origin: f3, direction: f3, testDistance: Float, customMatrix: f4x4) -> Bool {
        
        let model = mockModel(customMatrix: customMatrix)
        let inverseModel = simd_inverse(model)
        
        let cameraOrigin = f4(origin.x, origin.y, origin.z, 1) * inverseModel
        let localCameraDirection = f4(direction.x, direction.y, direction.z, 1) * inverseModel
        let selfPos = f4(0, 0, 0, 1) * inverseModel
        let localCameraOrigin = cameraOrigin - selfPos
        
        
        
        let selfPos_f3 = f3(selfPos.x, selfPos.y, selfPos.z)
        let localCameraOrigin_f3 = f3(localCameraOrigin.x, localCameraOrigin.y, localCameraOrigin.z)
        let localCameraDirection_f3 = f3(localCameraDirection.x, localCameraDirection.y, localCameraDirection.z)
        
        let a = model * f4(0, 0, 1, 1)

        let A = origin
        let B = localCameraOrigin_f3 + localCameraDirection_f3 * testDistance
        let n = simd_normalize(f3(a.x, a.y, a.z) - selfPos_f3)
        let P = selfPos_f3

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return false
        }
        
        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        if abs(x.x) < self.scale.x && abs(x.y) < self.scale.y {
            return true
        }
        
        return false
    }
}
