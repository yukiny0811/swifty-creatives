//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/12.
//

public enum EasyCameraType {
    case manual
    
    /// polarSpacing: defines how much camera can move along y axis in the screen.
    /// set this number small to allow the camera to move more freely.
    /// 0.0...1.0
    case easy(polarSpacing: Float)
    case flexible
}
