//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

public protocol CameraConfigBase {
    static var fov: Float { get }
    static var near: Float { get }
    static var far: Float { get }
    static var polarSpacing: Float { get }
}
