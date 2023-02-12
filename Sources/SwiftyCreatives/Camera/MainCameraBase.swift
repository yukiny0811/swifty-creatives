//
//  MainCameraBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

public protocol MainCameraBase {
    var mainMatrix: [f4x4] { get set }
    var perspectiveMatrix: [f4x4] { get set }
    
    // mutating func
    func translate(_ x: Float, _ y: Float, _ z: Float)
    func rotateAroundX(_ rad: Float)
    func rotateAroundY(_ rad: Float)
    func rotateAroundZ(_ rad: Float)
    func rotateAroundVisibleX(_ rad: Float)
    func rotateAroundVisibleY(_ rad: Float)
    func rotateAroundVisibleZ(_ rad: Float)
    func setTranslate(_ x: Float, _ y: Float, _ z: Float)
    func setRotation(rad: Float, axis: f3)
    
    // mock mutating func
    func mock_rotateAroundVisibleX(_ rad: Float) -> f4x4
    
    func setFrame(width: Float, height: Float)
    func screenToWorldDirection(x: Float, y: Float, width: Float, height: Float) -> (origin: f3, direction: f3)
    func getCameraPos() -> f3
}
