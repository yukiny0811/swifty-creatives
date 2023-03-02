//
//  HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import simd

open class HitTestableBox {
    
    internal let front = HitTestableRect()
    internal let back = HitTestableRect()
    internal let l = HitTestableRect()
    internal let r = HitTestableRect()
    internal let top = HitTestableRect()
    internal let bottom = HitTestableRect()
    
    public var scale: f3 { _mScale[0] }
    
    internal var _mScale: [f3] = [f3.one]
    internal var _material: [Material] = [Material(ambient: f3(1, 1, 1), diffuse: f3(1, 1, 1), specular: f3.one, shininess: 50)]
    
    public required init() {
        setScale(scale)
    }
    
    @discardableResult
    public func setScale(_ value: f3) -> Self {
        _mScale[0] = value
        front      .setScale(f3(scale.x, scale.y, 0))
        back       .setScale(f3(scale.x, scale.y, 0))
        l       .setScale(f3(scale.z, scale.y, 0))
        r      .setScale(f3(scale.z, scale.y, 0))
        top        .setScale(f3(scale.x, scale.z, 0))
        bottom     .setScale(f3(scale.x, scale.z, 0))
        return self
    }
    
    @discardableResult
    public func setMaterial(_ material: Material) -> Self {
        _material[0] = material
        return self
    }
    
    internal func draw(_ encoder: SCEncoder) {}
    
}

extension HitTestableBox {
    public func hitTest(origin: f3, direction: f3, testDistance: Float = 3000) -> f3? {
        var nearestDistance: Float? = nil
        var nearestHitPos: f3? = nil
        if let hitPos = front.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        if let hitPos = back.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        if let hitPos = l.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        if let hitPos = r.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        if let hitPos = top.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        if let hitPos = bottom.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
        }
        guard let _ = nearestDistance, let nearestHitPos = nearestHitPos else {
            return nil
        }
        return nearestHitPos
    }
    
    private func calculateNearest(origin: f3, hitPos: f3, nearestDistance: inout Float?, nearestHitPos: inout f3?) {
        let currentDistance = simd_distance(origin, hitPos)
        if let dist = nearestDistance {
            if currentDistance < dist {
                nearestDistance = currentDistance
                nearestHitPos = hitPos
            }
        } else {
            nearestDistance = currentDistance
            nearestHitPos = hitPos
        }
    }
}
