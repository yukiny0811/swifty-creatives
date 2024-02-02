//
//  DefaultOrthoConfig.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

/// Default camera config for orthographic projection.
public class DefaultOrthographicConfig: CameraConfig {
    public override init(
        fov: Float = 85,
        near: Float = -1000,
        far: Float = 1000,
        easyCameraType: EasyCameraType = .manual,
        isPerspective: Bool = false
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
