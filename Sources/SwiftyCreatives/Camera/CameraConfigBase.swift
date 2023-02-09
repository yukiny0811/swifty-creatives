//
//  CameraConfigBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

/// Config for Camera
public protocol CameraConfigBase {
    
    /// field of view in radians
    static var fov: Float { get }
    
    /// near clipping distance
    static var near: Float { get }
    
    /// far clipping distance
    static var far: Float { get }
    
    /// defines how much camera can move along y axis in the screen.
    /// set this number small to allow the camera to move more freely.
    /// 0.0...1.0
    static var polarSpacing: Float { get }
    
    /// enable easy move
    static var enableEasyMove: Bool { get }
    
    /// perspective or orthographic camera.
    /// orthographic if false
    static var isPerspective: Bool { get }
}
