//
//  CameraConfigBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

/// Config base for camera
public protocol CameraConfigBase {
    
    /// field of view in radians
    static var fov: Float { get }
    
    /// near clipping distance
    static var near: Float { get }
    
    /// far clipping distance
    static var far: Float { get }
    
    /// easy camera type
    static var easyCameraType: EasyCameraType { get }
    
    /// perspective or orthographic camera.
    /// orthographic if false
    static var isPerspective: Bool { get }
}
