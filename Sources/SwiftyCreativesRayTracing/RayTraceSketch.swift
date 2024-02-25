//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/07.
//

import Foundation
import MetalKit
import SwiftyCreatives

open class RayTraceSketch {
    
    public var objects: [RayTargetObject] = []
    public var pointLights: [PointLight] = []
    private var currentColor: f4 = .one
    
    public let rayTraceConfig: RayTraceConfig = .init()
    
    public init() {}
    
    func clearObjects() {
        objects.removeAll()
        pointLights.removeAll()
        currentColor = .one
    }
    
    open func updateUniform(uniform: inout RayTracingUniform) {}
    
    open func draw() {}
    
    public func addPointLight(pos: f3, color: f3, intensity: Float) {
        self.pointLights.append(
            PointLight(
                pos: pos,
                color: color,
                intensity: intensity
            )
        )
    }
    
    public func color(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        self.currentColor = f4(r, g, b, a)
    }
    
    public func box(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, _ scaleZ: Float, roughness: Float, metallic: Float, isMetal: Bool) {
        let boxObj = BoxRayTarget()
        boxObj.vertices = boxObj.vertices.map {
            RayTracingVertex(
                v1: f3(x + $0.v1.x * scaleX, y + $0.v1.y * scaleY, z + $0.v1.z * scaleZ),
                v2: f3(x + $0.v2.x * scaleX, y + $0.v2.y * scaleY, z + $0.v2.z * scaleZ),
                v3: f3(x + $0.v3.x * scaleX, y + $0.v3.y * scaleY, z + $0.v3.z * scaleZ),
                uv1: $0.uv1,
                uv2: $0.uv2,
                uv3: $0.uv3,
                normal: $0.normal,
                color: currentColor,
                roughness: roughness,
                metallic: metallic,
                isMetal: isMetal ? 1 : 0
            )
        }
        objects.append(boxObj)
    }
    
    public func rect(_ x: Float, _ y: Float, _ z: Float, _ scaleX: Float, _ scaleY: Float, roughness: Float, metallic: Float, isMetal: Bool) {
        let obj = RectRayTarget()
        obj.vertices = obj.vertices.map {
            RayTracingVertex(
                v1: f3(x + $0.v1.x * scaleX, y + $0.v1.y * scaleY, z + $0.v1.z * 0),
                v2: f3(x + $0.v2.x * scaleX, y + $0.v2.y * scaleY, z + $0.v2.z * 0),
                v3: f3(x + $0.v3.x * scaleX, y + $0.v3.y * scaleY, z + $0.v3.z * 0),
                uv1: $0.uv1,
                uv2: $0.uv2,
                uv3: $0.uv3,
                normal: $0.normal,
                color: currentColor,
                roughness: roughness,
                metallic: metallic,
                isMetal: isMetal ? 1 : 0
            )
        }
        objects.append(obj)
    }
}

public protocol RayTargetObject {
    var vertices: [RayTracingVertex] { get set }
}

public class RectRayTarget: RayTargetObject {
    public var vertices: [RayTracingVertex] = [
        RayTracingVertex(
            v1: RectShapeInfo.VertexPoint.A,
            v2: RectShapeInfo.VertexPoint.B,
            v3: RectShapeInfo.VertexPoint.D,
            uv1: f2(0, 0),
            uv2: f2(0, 1),
            uv3: f2(1, 0),
            normal: f3(0, 0, 1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: RectShapeInfo.VertexPoint.B,
            v2: RectShapeInfo.VertexPoint.D,
            v3: RectShapeInfo.VertexPoint.C,
            uv1: f2(0, 1),
            uv2: f2(1, 0),
            uv3: f2(1, 1),
            normal: f3(0, 0, 1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
    ]
}

public class BoxRayTarget: RayTargetObject {
    public var vertices: [RayTracingVertex] = [
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.A,
            v2: BoxInfo.VertexPoint.B,
            v3: BoxInfo.VertexPoint.C,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 0, 1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.A,
            v2: BoxInfo.VertexPoint.C,
            v3: BoxInfo.VertexPoint.D,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 0, 1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.R,
            v2: BoxInfo.VertexPoint.T,
            v3: BoxInfo.VertexPoint.S,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 0, -1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.Q,
            v2: BoxInfo.VertexPoint.R,
            v3: BoxInfo.VertexPoint.S,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 0, -1),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.Q,
            v2: BoxInfo.VertexPoint.S,
            v3: BoxInfo.VertexPoint.B,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(-1, 0, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.Q,
            v2: BoxInfo.VertexPoint.B,
            v3: BoxInfo.VertexPoint.A,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(-1, 0, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.D,
            v2: BoxInfo.VertexPoint.C,
            v3: BoxInfo.VertexPoint.T,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(1, 0, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.D,
            v2: BoxInfo.VertexPoint.T,
            v3: BoxInfo.VertexPoint.R,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(1, 0, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.Q,
            v2: BoxInfo.VertexPoint.A,
            v3: BoxInfo.VertexPoint.D,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 1, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.Q,
            v2: BoxInfo.VertexPoint.D,
            v3: BoxInfo.VertexPoint.R,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, 1, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.B,
            v2: BoxInfo.VertexPoint.S,
            v3: BoxInfo.VertexPoint.T,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, -1, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
        RayTracingVertex(
            v1: BoxInfo.VertexPoint.B,
            v2: BoxInfo.VertexPoint.T,
            v3: BoxInfo.VertexPoint.C,
            uv1: .zero,
            uv2: .zero,
            uv3: .zero,
            normal: f3(0, -1, 0),
            color: .one,
            roughness: 0.0,
            metallic: 0.0,
            isMetal: 0
        ),
    ]
}

