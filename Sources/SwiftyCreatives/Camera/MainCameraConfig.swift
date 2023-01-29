//
//  MainCameraConfig.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

public final class MainCameraConfig: CameraConfigBase {
    public static var fov: Float = 85
    public static var near: Float = 0.01
    public static var far: Float = 100.0
    public static var polarSpacing: Float = 0.97
    public static var enableEasyMove: Bool = true
    public static var isPerspective: Bool = true
}
