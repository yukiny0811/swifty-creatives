//
//  CornerRadiusPP.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

import Metal

public class CornerRadiusPP: PostProcessor {
    public init() {
        super.init(functionName: "cornerRadiusPostProcess", slowFunctionName: "cornerRadiusPostProcess_Slow", bundle: .module)
    }
    public func radius(_ rad: Float) -> Self {
        args = [rad]
        return self
    }
}
