//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/30.
//

import Foundation

public final class DefaultOrthoConfig: CameraConfigBase {
    public static var fov: Float = 85
    
    public static var near: Float = -300
    
    public static var far: Float = 300
    
    public static var polarSpacing: Float = 0.97
    
    public static var enableEasyMove: Bool = true
    
    public static var isPerspective: Bool = false
    
    
}
