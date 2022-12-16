//
//  MainCamera.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import GLKit

public class MainCamera<
    Config: CameraConfigBase
>: MainCameraBase {
    
    var frameWidth: Float = 0
    var frameHeight: Float = 0
    
    var matrix: GLKMatrix4
    var matrixX: GLKMatrix4
    var matrixY: GLKMatrix4
    var matrixT: GLKMatrix4
    
    var mainMatrix: [f4x4] = [f4x4(0)]
    var perspectiveMatrix: [f4x4] = [f4x4(0)]
    
    public init() {
        matrixX = GLKMatrix4Identity
        matrixY = GLKMatrix4Identity
        matrixT = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -30)
        matrix = GLKMatrix4Multiply(GLKMatrix4Multiply(matrixT, matrixX), matrixY)
        updateMatrix()
    }
    
    public func translate(_ x: Float, _ y: Float, _ z: Float) {
        matrix = GLKMatrix4Translate(matrix, x, y, z)
        updateMatrix()
    }
    
    public func rotateAroundX(_ rad: Float) {
        if rad >= 0.0 && matrixX.m.6 >= Config.polarSpacing { return }
        if rad <= 0.0 && matrixX.m.6 <= -Config.polarSpacing { return }
        matrixX = GLKMatrix4RotateX(matrixX, rad)
        matrix = GLKMatrix4Multiply(GLKMatrix4Multiply(matrixT, matrixX), matrixY)
        updateMatrix()
    }
    public func rotateAroundY(_ rad: Float) {
        matrixY = GLKMatrix4RotateY(matrixY, rad)
        matrix = GLKMatrix4Multiply(GLKMatrix4Multiply(matrixT, matrixX), matrixY)
        updateMatrix()
    }
    public func rotateAroundZ(_ rad: Float) {
        matrix = GLKMatrix4RotateZ(matrix, rad)
        updateMatrix()
    }
    
    public func updateMatrix() {
        mainMatrix[0] = matrix.toSimd()
    }
    public func updatePMatrix() {
        let pmat = GLKMatrix4MakePerspective(
            GLKMathDegreesToRadians(Config.fov),
            frameWidth / frameHeight,
            Config.near,
            Config.far
        )
        perspectiveMatrix[0] = pmat.toSimd()
    }
    
    public func setFrame(width: Float, height: Float) {
        if self.frameWidth != width || self.frameHeight != height {
            self.frameWidth = width
            self.frameHeight = height
            updatePMatrix()
        }
    }
}

