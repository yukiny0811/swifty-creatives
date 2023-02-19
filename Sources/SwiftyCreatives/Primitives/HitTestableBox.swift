//
//  HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import simd

public class HitTestableBox: PrimitiveBase {
    
    private let front = Rect()
    private let back = Rect()
    private let l = Rect()
    private let r = Rect()
    private let top = Rect()
    private let bottom = Rect()
    
    public var color: f4 { _color[0] }
    public var pos: f3 { _mPos[0] }
    public var rot: f3 { _mRot[0] }
    public var scale: f3 { _mScale[0] }
    
    internal var _color: [f4] = [f4.zero]
    internal var _mPos: [f3] = [f3.zero]
    internal var _mRot: [f3] = [f3.zero]
    internal var _mScale: [f3] = [f3.one]
    internal var _material: [Material] = [Material(ambient: f3(1, 1, 1), diffuse: f3(1, 1, 1), specular: f3.one, shininess: 50)]
    
    private var cachedCustomMatrix: f4x4 = f4x4.createIdentity()
    
    public required init() {
        setColor(color)
        setPos(pos)
        setRot(rot)
        setScale(scale)
    }
    
    @discardableResult
    public func setColor(_ value: f4) -> Self {
        _color[0] = value
//        front.setColor(color)
//        back.setColor(color)
//        l.setColor(color)
//        r.setColor(color)
//        top.setColor(color)
        bottom.setColor(color)
        return self
    }
    
    @discardableResult
    public func setPos(_ value: f3) -> Self {
        _mPos[0] = value
//        front   .setPos(pos + f3(0, 0, scale.z))
//        back    .setPos(pos + f3(0, 0, -scale.z))
//        l    .setPos(pos + f3(-scale.x, 0, 0))
//        r   .setPos(pos + f3(scale.x, 0, 0))
//        top     .setPos(pos + f3(0, scale.y, 0))
        bottom  .setPos(pos + f3(0, -scale.y, 0))
        return self
    }
    
    @discardableResult
    public func setRot(_ value: f3) -> Self {
        _mRot[0] = value
//        front    .setRot(f3.zero)
//        back     .setRot(f3.zero)
//        l     .setRot(f3(0, Float.pi / 2, 0))
//        r    .setRot(f3(0, -Float.pi / 2, 0))
//        top      .setRot(f3(Float.pi / 2, 0, 0))
        bottom   .setRot(f3(-Float.pi / 2, 0, 0))
        return self
    }
    
    @discardableResult
    public func setScale(_ value: f3) -> Self {
        _mScale[0] = value
//        front      .setScale(f3(scale.x, scale.y, 1))
//        back       .setScale(f3(scale.x, scale.y, 1))
//        l       .setScale(f3(scale.z, scale.y, 1))
//        r      .setScale(f3(scale.z, scale.y, 1))
//        top        .setScale(f3(scale.x, scale.z, 1))
        bottom     .setScale(f3(scale.x, scale.z, 1))
        return self
    }
    
    @discardableResult
    public func setMaterial(_ material: Material) -> Self {
        _material[0] = material
        return self
    }
    
    public func drawWithCache(_ encoder: SCEncoder, customMatrix: f4x4) {
//        front.drawWithCache(encoder: encoder, customMatrix: customMatrix)
//        back.drawWithCache(encoder: encoder, customMatrix: customMatrix)
//        l.drawWithCache(encoder: encoder, customMatrix: customMatrix)
//        r.drawWithCache(encoder: encoder, customMatrix: customMatrix)
//        top.drawWithCache(encoder: encoder, customMatrix: customMatrix)
        bottom.drawWithCache(encoder: encoder, customMatrix: customMatrix)
        self.cachedCustomMatrix = customMatrix
    }
    
    public func draw(_ encoder: SCEncoder) {
//        front.draw(encoder)
//        back.draw(encoder)
//        l.draw(encoder)
//        r.draw(encoder)
//        top.draw(encoder)
//        bottom.draw(encoder)
    }
    
}

extension HitTestableBox {
    public func hitTest(origin: f3, direction: f3, testDistance: Float = 3000) -> f3? {
        var nearestDistance: Float? = nil
        var nearestHitPos: f3? = nil
//        if let hitPos = front.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
//            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
//        }
//        if let hitPos = back.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
//            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
//        }
//        if let hitPos = l.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
//            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
//        }
//        if let hitPos = r.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
//            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
//        }
//        if let hitPos = top.hitTestGetPos(origin: origin, direction: direction, testDistance: testDistance) {
//            calculateNearest(origin: origin, hitPos: hitPos, nearestDistance: &nearestDistance, nearestHitPos: &nearestHitPos)
//        }
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
