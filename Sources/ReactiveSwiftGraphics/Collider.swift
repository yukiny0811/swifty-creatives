//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives
import SwiftUI

public enum Collider: Equatable {
    case none
    case sphere(radius: Float)
    case box(xLength: Float, yLength: Float, zLength: Float)

    func didCollide(ray: (origin: f3, direction: f3), mat: f4x4) -> Bool {
        switch self {
        case .none:
            return false
        case .sphere(let radius):
            return false
        case .box(let xLength, let yLength, let zLength):
            let mat1: f4x4 = .createTransform(xLength, 0, 0) * .createScale(1, yLength, zLength) * .createRotation(angle: Float.pi / 2, axis: f3(0, 1, 0))
            let hitResult1 = Self.calculateBoxHitTest(
                customMatrix: mat * mat1,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            let mat2: f4x4 = .createTransform(-xLength, 0, 0) * .createScale(1, yLength, zLength) * .createRotation(angle: Float.pi / 2, axis: f3(0, 1, 0))
            let hitResult2 = Self.calculateBoxHitTest(
                customMatrix: mat * mat2,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            let mat3: f4x4 = .createTransform(0, yLength, 0) * .createScale(xLength, 1, zLength) * .createRotation(angle: Float.pi / 2, axis: f3(1, 0, 0))
            let hitResult3 = Self.calculateBoxHitTest(
                customMatrix: mat * mat3,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            let mat4: f4x4 = .createTransform(0, -yLength, 0) * .createScale(xLength, 1, zLength) * .createRotation(angle: Float.pi / 2, axis: f3(1, 0, 0))
            let hitResult4 = Self.calculateBoxHitTest(
                customMatrix: mat * mat4,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            let mat5: f4x4 = .createTransform(0, 0, zLength) * .createScale(xLength, yLength, 1)
            let hitResult5 = Self.calculateBoxHitTest(
                customMatrix: mat * mat5,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            let mat6: f4x4 = .createTransform(0, 0, -zLength) * .createScale(xLength, yLength, 1)
            let hitResult6 = Self.calculateBoxHitTest(
                customMatrix: mat * mat6,
                origin: ray.origin,
                direction: ray.direction,
                testDistance: 1000,
                scale: f3(xLength, yLength, zLength)
            )

            if hitResult1 == nil && hitResult2 == nil && hitResult3 == nil && hitResult4 == nil && hitResult5 == nil && hitResult6 == nil {
                return false
            } else {
                return true
            }
        }
    }

    public static func calculateBoxHitTest(customMatrix: f4x4, origin: f3, direction: f3, testDistance: Float, scale: f3) -> (globalPos: f3, localPos: f3)? {

        let model = f4x4.createIdentity()
        let customModel = customMatrix.transpose

        var selfPos_f4 = f4(0, 0, 0, 1) * model
        selfPos_f4.w = 1
        selfPos_f4 = selfPos_f4 * customModel

        let selfPos = f3(selfPos_f4.x, selfPos_f4.y, selfPos_f4.z)

        var a = f4(0, 0, 1000, 1) * model
        a.w = 1
        a = a * customModel

        let A = origin
        let B = origin + direction * testDistance

        let n = simd_normalize(f3(a.x, a.y, a.z) - selfPos)

        let P = selfPos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)

        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )

        let inverseModel = model.inverse
        let inverseCustomModel = customModel.inverse
        var processedLocalPos = f4(x.x, x.y, x.z, 1) * inverseCustomModel
        processedLocalPos.w = 1
        processedLocalPos = processedLocalPos * inverseModel

        guard abs(processedLocalPos.x) <= scale.x && abs(processedLocalPos.y) <= scale.y else {
            return nil
        }

        let processedLocalPos_f3 = f3(processedLocalPos.x, processedLocalPos.y, processedLocalPos.z)

        return (x, processedLocalPos_f3)
    }
}
