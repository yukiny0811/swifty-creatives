//
//  GLKMatrix4+.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import GLKit

extension GLKMatrix4 {
    func toSimd() -> simd_float4x4 {
        simd_float4x4 (
            [
                simd_float4(self.m00, self.m01, self.m02, self.m03),
                simd_float4(self.m10, self.m11, self.m12, self.m13),
                simd_float4(self.m20, self.m21, self.m22, self.m23),
                simd_float4(self.m30, self.m31, self.m32, self.m33)
            ]
        )
    }
}
