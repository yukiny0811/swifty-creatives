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
    
    public var mainMatrix: [f4x4] = [f4x4(0)]
    public var perspectiveMatrix: [f4x4] = [f4x4(0)]
    
    public init() {
        matrixX = f4x4.createIdentity().toGLKMatrix4()
        matrixY = f4x4.createIdentity().toGLKMatrix4()
        matrixT = f4x4.createTransform(0, 0, -20).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    
    public func setTranslate(_ x: Float, _ y: Float, _ z: Float) {
        matrixT = f4x4.createTransform(x, y, z).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    
    public func translate(_ x: Float, _ y: Float, _ z: Float) {
        matrixT = (matrixT.toSimd() * f4x4.createTransform(x, y, z)).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    
    public func setRotation(_ x: Float, _ y: Float, _ z: Float) {
        matrixX = f4x4.createRotation(angle: x, axis: f3(1, 0, 0)).toGLKMatrix4()
        matrixY = f4x4.createRotation(angle: y, axis: f3(0, 1, 0)).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    
    public func rotateAroundX(_ rad: Float) {
        if rad >= 0.0 && matrixX.m.6 >= Config.polarSpacing { return }
        if rad <= 0.0 && matrixX.m.6 <= -Config.polarSpacing { return }
        matrixX = (matrixX.toSimd() * f4x4.createRotation(angle: rad, axis: f3(1, 0, 0))).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    public func rotateAroundY(_ rad: Float) {
        matrixY = (matrixY.toSimd() * f4x4.createRotation(angle: rad, axis: f3(0, 1, 0))).toGLKMatrix4()
        matrix = (matrixT.toSimd() * matrixX.toSimd() * matrixY.toSimd()).toGLKMatrix4()
        updateMatrix()
    }
    public func rotateAroundZ(_ rad: Float) {
        matrix = (matrix.toSimd() * f4x4.createRotation(angle: rad, axis: f3(0, 0, 1))).toGLKMatrix4()
        updateMatrix()
    }
    
    public func updateMatrix() {
        mainMatrix[0] = matrix.toSimd()
    }
    public func updatePMatrix() {
        if Config.isPerspective {
            perspectiveMatrix[0] = f4x4.createPerspective(fov: Float.degreesToRadians(Config.fov), aspect: frameWidth / frameHeight, near: Config.near, far: Config.far)
        } else {
            perspectiveMatrix[0] = f4x4.createOrthographic(-self.frameWidth/2, self.frameWidth/2, -self.frameHeight/2, self.frameHeight/2, Config.near, Config.far)
        }
    }
    
    public func setFrame(width: Float, height: Float) {
        if self.frameWidth != width || self.frameHeight != height {
            self.frameWidth = width
            self.frameHeight = height
            updatePMatrix()
        }
    }
    
    public func getCameraPos() -> f3 {
        let viewInv = simd_inverse(self.mainMatrix[0])
        let cameraOrigin = f4(0, 0, 0, 1)
        let temp2 = viewInv * cameraOrigin
        let worldOrigin = f3(temp2.x, temp2.y, temp2.z)
        return worldOrigin
    }
    
    /// view points (not normalized)
    public func screenToWorldDirection(x: Float, y: Float, width: Float, height: Float) -> (origin: f3, direction: f3) {

        var x = x - width/2
        var y = -(y - height/2)

        x /= width
        y /= height

        x *= 2
        y *= 2

        let clipCoordinate = f4(x, y, 0, 1)

        let projInv = simd_inverse(self.perspectiveMatrix[0])
        let viewInv = simd_inverse(self.mainMatrix[0])

        var cameraDirection = projInv * clipCoordinate
        cameraDirection.z = -1
        cameraDirection.w = 0

        let temp = viewInv * cameraDirection
        let worldDirection = normalize(f3(temp.x, temp.y, temp.z))

        let cameraOrigin = f4(0, 0, 0, 1)
        let temp2 = viewInv * cameraOrigin
        let worldOrigin = f3(temp2.x, temp2.y, temp2.z)
        
        return (worldOrigin, worldDirection)
    }
}

