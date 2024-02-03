//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import Foundation

/// Default camera config for perspective projection.
public class DefaultPerspectiveConfig: CameraConfig {
    public override init(
        fov: Float = 85,
        near: Float = 0.01,
        far: Float = 1000,
        easyCameraType: EasyCameraType = .easy(polarSpacing: 0.03),
        isPerspective: Bool = true
    ) {
        super.init(
            fov: fov,
            near: near,
            far: far,
            easyCameraType: easyCameraType,
            isPerspective: isPerspective
        )
    }
}
