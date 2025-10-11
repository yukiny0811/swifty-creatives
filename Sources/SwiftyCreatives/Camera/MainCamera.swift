//
//  MainCamera.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import simd

public class MainCamera {
    
    var frameWidth: Float = 0
    var frameHeight: Float = 0
    
    public var matrixR: f4x4
    public var matrixT: f4x4

    private let axisX = f4(1, 0, 0, 1)
    private let axisY = f4(0, 1, 0, 1)
    private let axisZ = f4(0, 0, 1, 1)
    
    public var mainMatrix: [f4x4] = [f4x4(0)]
    public var perspectiveMatrix: [f4x4] = [f4x4(0)]
    
    public var config: CameraConfig
    
    public init(
        config: CameraConfig
    ) {
        self.config = config
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
    
    public func rotateAroundVisibleX(_ rad: Float, customMatrixR: f4x4? = nil) {
        if let customMatrixR {
            let currentAxis = axisX * customMatrixR
            matrixR = customMatrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        } else {
            let currentAxis = axisX * matrixR
            matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        }
        updateMainMatrix()
    }
    
    public func rotateAroundVisibleY(_ rad: Float, customMatrixR: f4x4? = nil) {
        if let customMatrixR {
            let currentAxis = axisY * customMatrixR
            matrixR = customMatrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        } else {
            let currentAxis = axisY * matrixR
            matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        }
        updateMainMatrix()
    }
    
    public func rotateAroundVisibleZ(_ rad: Float, customMatrixR: f4x4? = nil) {
        if let customMatrixR {
            let currentAxis = axisZ * customMatrixR
            matrixR = customMatrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        } else {
            let currentAxis = axisZ * matrixR
            matrixR = matrixR * f4x4.createRotation(angle: rad, axis: f3(currentAxis.x, currentAxis.y, currentAxis.z))
        }
        updateMainMatrix()
    }
    
    public func updateMainMatrix() {
        mainMatrix[0] = matrixT * matrixR
    }
    
    public func updatePMatrix() {
        if config.isPerspective {
            perspectiveMatrix[0] = f4x4.createPerspective(fov: Float.degreesToRadians(config.fov), aspect: frameWidth / frameHeight, near: config.near, far: config.far)
        } else {
            perspectiveMatrix[0] = f4x4.createOrthographic(-self.frameWidth/2, self.frameWidth/2, -self.frameHeight/2, self.frameHeight/2, config.near, config.far)
        }
    }
    
    public func setFov(to degrees: Float) {
        config.fov = degrees
        updatePMatrix()
    }

    public func setFrame(width: Float, height: Float) {
        if self.frameWidth != width || self.frameHeight != height {
            self.frameWidth = width
            self.frameHeight = height
            updatePMatrix()
        }
    }
    
    public func getCameraPos() -> f3 {
        let viewInv = self.mainMatrix[0].inverse
        let cameraOrigin = f4(0, 0, 0, 1)
        let temp2 = viewInv * cameraOrigin
        let worldOrigin = f3(temp2.x, temp2.y, temp2.z)
        return worldOrigin
    }
    
    /// view points (not normalized)
    public func screenToWorldDirection(x: Float, y: Float) -> (origin: f3, direction: f3) {
        var x = x
        var y = y
        x = x * 2 - 1
        y = y * 2 - 1

        let clipCoordinate = f4(x, y, 0, 1)

        let projInv = self.perspectiveMatrix[0].inverse
        let viewInv = self.mainMatrix[0].inverse

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
    
    public func screenToWorldDirection(screenPos: f2) -> (origin: f3, direction: f3) {
        var x = screenPos.x
        var y = screenPos.y
        x = x * 2 - 1
        y = y * 2 - 1

        let clipCoordinate = f4(x, y, 0, 1)

        let projInv = self.perspectiveMatrix[0].inverse
        let viewInv = self.mainMatrix[0].inverse

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
    
    public func screenToWorldDirection(screenPos: f2, viewSize: f2) -> (origin: f3, direction: f3) {

        var x = screenPos.x - viewSize.x/2
        var y = -(screenPos.y - viewSize.y/2)

        x /= viewSize.x
        y /= viewSize.y

        x *= 2
        y *= 2

        let clipCoordinate = f4(x, y, 0, 1)

        let projInv = self.perspectiveMatrix[0].inverse
        let viewInv = self.mainMatrix[0].inverse

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

    public func lookAt(eye: f3, center: f3, up: f3 = f3(0, 1, 0)) {
        var fwd = normalize(center - eye)
        if simd_length(fwd) < 1e-6 {
            fwd = f3(0, 0, -1) // fallback
        }

        var up = simd_normalize(up)

        var right = cross(fwd, up)
        if simd_length(right) < 1e-6 {
            // fwd と up が平行 → 別軸を使う
            let aux = abs(fwd.x) < 0.9 ? f3(1,0,0) : f3(0,1,0)
            right = cross(fwd, aux)
        }
        right = normalize(right)

        let upTrue = normalize(cross(right, fwd)) // ←ここはもう安全

        // 列優先（column-major）で right, up, -forward の順に
        let rotation = f4x4(columns: (
            f4(right,    0),
            f4(upTrue,   0),
            f4(-fwd,     0),
            f4(0, 0, 0, 1)
        ))

        let translation = f4x4.createTransform(eye.x, eye.y, eye.z)
        matrixR = rotation
        matrixT = translation
        updateMainMatrix()
    }

    public var right: f3 {
        let R = matrixR
        return normalize(f3(R.columns.0.x, R.columns.0.y, R.columns.0.z))
    }

    public var up: f3 {
        let R = matrixR
        return normalize(f3(R.columns.1.x, R.columns.1.y, R.columns.1.z))
    }

    public var lookingDirection: f3 {
        let R = matrixR
        return normalize(-f3(R.columns.2.x, R.columns.2.y, R.columns.2.z))
    }

    public var eye: f3 {
        let viewInv = mainMatrix[0].inverse
        let cameraOrigin = f4(0, 0, 0, 1)
        let worldPos = viewInv * cameraOrigin
        return f3(worldPos.x, worldPos.y, worldPos.z)
    }

    /// カメラの right ベクトルを、指定した法線ベクトル v に対して水平に補正する
    /// - Parameter v: 法線ベクトル（例: 地球の Up ベクトル）
    public func makeRightHorizontal(to v: f3) {
        // 1️⃣ 法線を正規化
        let n = simd_normalize(v)

        // 2️⃣ カメラの right/up を取得（ワールド座標）
        let r = simd_normalize(self.right)
        let u = simd_normalize(self.up)

        // 3️⃣ up の「垂直成分」を取り除いて、v に垂直な平面上の up' を作る
        //     → この up' が「地面に投影された up」方向
        let projectedUp = simd_normalize(u - simd_dot(u, n) * n)

        // 4️⃣ 現在の right が、n に対してどれだけ roll しているかを算出
        // right と (n × projectedUp) のなす角度を求める
        let idealRight = simd_normalize(simd_cross(n, projectedUp))
        let cosAngle = simd_clamp(simd_dot(r, idealRight), -1.0, 1.0)
        let angle = acos(cosAngle)

        // 5️⃣ 回転方向（符号）を決定：どっちに回すかは up の向きで判断
        let sign: Float = simd_dot(simd_cross(r, idealRight), n) < 0 ? -1 : 1
        let rollAngle = angle * sign

        // 6️⃣ roll 角分だけZ軸（見た目の軸）で回転して水平にする
        self.rotateAroundVisibleZ(-rollAngle)
    }
}

