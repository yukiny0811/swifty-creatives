//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/27.
//

@propertyWrapper
public class SCAnimatable {
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
    public func update(multiplier: Float) {
        let diff = targetValue - value
        let changeValue = diff * multiplier
        value += changeValue
    }
}
