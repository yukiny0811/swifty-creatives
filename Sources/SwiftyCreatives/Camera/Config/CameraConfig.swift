//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import Foundation

/// Config for camera
public class CameraConfig {
    
    /// field of view in radians
    public var fov: Float
    
    /// near clipping distance
    public var near: Float
    
    /// far clipping distance
    public var far: Float
    
    /// easy camera type
    public var easyCameraType: EasyCameraType
    
    /// perspective or orthographic camera.
    /// orthographic if false
    public var isPerspective: Bool
    
    public init(
        fov: Float,
        near: Float,
        far: Float,
        easyCameraType: EasyCameraType,
        isPerspective: Bool
    ) {
        self.fov = fov
        self.near = near
        self.far = far
        self.easyCameraType = easyCameraType
        self.isPerspective = isPerspective
    }
}
