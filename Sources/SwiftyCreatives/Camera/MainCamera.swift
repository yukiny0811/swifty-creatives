//
//  MainCamera.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import simd

public class MainCamera<
    Config: CameraConfigBase
>: MainCameraBase {
    
    var frameWidth: Float = 0
    var frameHeight: Float = 0
    
    var matrixR: f4x4
    var matrixT: f4x4
    
    private let axisX = f4(1, 0, 0, 1)
    private let axisY = f4(0, 1, 0, 1)
    private let axisZ = f4(0, 0, 1, 1)
    
    public var mainMatrix: [f4x4] = [f4x4(0)]
    public var perspectiveMatrix: [f4x4] = [f4x4(0)]
    
    public init() {
        matrixR = f4x4.createIdentity()
        matrixT = f4x4.createTransform(0, 0, -20)
        updateMainMatrix()
    }
    
    public func setTranslate(_ x: Float, _ y: Float, _ z: Float) {
        matrixT = f4x4.createTransform(x, y, z)
        updateMainMatrix()
    }
    
    public func translate(_ x: Float, _ y: Float, _ z: Float) {
        matrixT = matrixT * f4x4.createTransform(x, y, z)
        updateMainMatrix()
    }
    
    public func setRotation(rad: Float, axis: f3) {
        matrixR = f4x4.createRotation(angle: rad, axis: axis)
        updateMainMatrix()
    }
    
    public func rotate(rad: Float, axis: f3) {
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: axis)
        updateMainMatrix()
    }
    
    public func rotateAroundX(_ rad: Float) {
        let currentAxis = axisX
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    public func rotateAroundY(_ rad: Float) {
        let currentAxis = axisY
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    public func rotateAroundZ(_ rad: Float) {
        let currentAxis = axisZ
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    public func rotateAroundVisibleX(_ rad: Float) {
        let currentAxis = axisX * matrixR
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    public func rotateAroundVisibleY(_ rad: Float) {
        let currentAxis = axisY * matrixR
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    public func rotateAroundVisibleZ(_ rad: Float) {
        let currentAxis = axisZ * matrixR
        matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        updateMainMatrix()
    }
    
    private func updateMainMatrix() {
        mainMatrix[0] = matrixT * matrixR
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
    
    public func mock_rotateAroundVisibleX(_ rad: Float) -> f4x4 {
        let currentAxis = axisX * matrixR
        let mockMatrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        return matrixT * mockMatrixR
    }
}

