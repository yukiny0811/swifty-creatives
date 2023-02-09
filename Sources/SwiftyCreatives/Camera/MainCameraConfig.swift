//
//  MainCameraConfig.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

public class MainCameraConfig: CameraConfigBase {
    public static let fov: Float = 85
    public static let near: Float = 0.01
    public static let far: Float = 100.0
    public static let polarSpacing: Float = 0.03
    public static let enableEasyMove: Bool = true
    public static let isPerspective: Bool = true
}
