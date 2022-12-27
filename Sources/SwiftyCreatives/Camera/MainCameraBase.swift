//
//  MainCameraBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

public protocol MainCameraBase {
    var mainMatrix: [f4x4] { get set }
    var perspectiveMatrix: [f4x4] { get set }
    func translate(_ x: Float, _ y: Float, _ z: Float)
    func rotateAroundX(_ rad: Float)
    func rotateAroundY(_ rad: Float)
    func rotateAroundZ(_ rad: Float)
    func setFrame(width: Float, height: Float)
    func screenToWorldDirection(x: Float, y: Float, width: Float, height: Float) -> (origin: f3, direction: f3)
    func setTranslate(_ x: Float, _ y: Float, _ z: Float)
    func setRotation(_ x: Float, _ y: Float, _ z: Float)
}
