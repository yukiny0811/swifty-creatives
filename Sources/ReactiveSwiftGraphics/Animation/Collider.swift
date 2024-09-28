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

    // returns nil if no collision, returns distance from camera if collided
    func didCollide(ray: (origin: f3, direction: f3), mat: f4x4) -> Float? {
        switch self {
        case .none:
            return nil
        case .sphere(let radius):
            var selfPos_f4 = f4(0, 0, 0, 1) * f4x4.createIdentity()
            selfPos_f4.w = 1
            selfPos_f4 = selfPos_f4 * mat.transpose
            let thisPosition: f3 = f3(selfPos_f4.x, selfPos_f4.y, selfPos_f4.z)
            if let intersectionPos = Self.didSphereIntersect(origin: ray.origin, direction: ray.direction, sphereCenterPosition: thisPosition, sphereRadius: radius) {
                let distance: Float = simd_distance(ray.origin, intersectionPos)
                return distance
            } else {
                return nil
            }
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
                return nil
            } else {
                var minDist: Float = 9999999
                if let hitResult1 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult1.globalPos))
                }
                if let hitResult2 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult2.globalPos))
                }
                if let hitResult3 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult3.globalPos))
                }
                if let hitResult4 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult4.globalPos))
                }
                if let hitResult5 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult5.globalPos))
                }
                if let hitResult6 {
                    minDist = min(minDist, simd_distance(ray.origin, hitResult6.globalPos))
                }
                return minDist
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

    public static func didSphereIntersect(origin: simd_float3, direction: simd_float3, sphereCenterPosition: simd_float3, sphereRadius: Float) -> simd_float3? {
        let oc = origin - sphereCenterPosition
        let a = dot(direction, direction)
        let b = 2.0 * dot(oc, direction)
        let c = dot(oc, oc) - sphereRadius * sphereRadius
        let discriminant = b * b - 4 * a * c

        if discriminant < 0 {
            // No intersection
            return nil
        } else {
            // Find the nearest intersection point (smallest positive t)
            let t1 = (-b - sqrt(discriminant)) / (2.0 * a)
            let t2 = (-b + sqrt(discriminant)) / (2.0 * a)

            // We want the smallest positive t (closest intersection)
            let t = min(t1, t2)
            if t > 0 {
                // Calculate the intersection point
                return origin + t * direction
            } else {
                return nil
            }
        }
    }
}
