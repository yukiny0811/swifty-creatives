//
//  SCAnimatable.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/27.
//

@propertyWrapper
public class SCAnimatable {
    public enum SCAnimationType {
        case linear
        case easeOut
    }
    private var value: Float
    private var targetValue: Float
    public var projectedValue: SCAnimatable { self }
    public init (wrappedValue: Float) {
        value = 0
        targetValue = wrappedValue
    }
    public var wrappedValue: Float {
        get { targetValue }
        set { targetValue = newValue }
    }
    public var animationValue: Float {
        get { value }
    }
    public func update(multiplier: Float, with type: SCAnimationType = .easeOut) {
        switch type {
        case .easeOut:
            let clampedMultiplier = multiplier.clamp(0...1)
            let diff = targetValue - value
            let changeValue = diff * clampedMultiplier
            value += changeValue
        case .linear:
            let diff = targetValue - value
            let clamped = diff.clamp(-multiplier...multiplier)
            value += clamped
        }
    }
}
