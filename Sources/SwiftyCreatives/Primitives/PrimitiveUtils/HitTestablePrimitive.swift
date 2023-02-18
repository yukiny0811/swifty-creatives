//
//  HitTestablePrimitive.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/31.
//

import simd

public class HitTestablePrimitive<Info: PrimitiveInfo>: Primitive<Info> {
    var cachedCustomMatrix: f4x4 = f4x4.createIdentity()
}
