//
//  EasyCameraType.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/12.
//

/// Easy Camera T
public enum EasyCameraType {
    
    /// Manual 3D Camera
    case manual
    
    /// Standard 3D Camera
    /// - Parameters:
    ///     - polarSpacing: defines how much camera can move along y axis in the screen. set this number small to allow the camera to move more freely. Should be 0.0...1.0
    case easy(polarSpacing: Float)
    
    /// Flexible 3D Camera
    case flexible
}
