//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import Foundation

@propertyWrapper
@Observable
public class GraphicsState<T: Equatable>: Equatable {

    public static func == (lhs: GraphicsState<T>, rhs: GraphicsState<T>) -> Bool {
        lhs.value == rhs.value
    }
    @ObservationIgnored
    public var prevValue: T

    @ObservationIgnored
    public var didChange = false

    var value: T

    @ObservationIgnored
    public var projectedValue: GraphicsState { self }
    public init (wrappedValue: T) {
        value = wrappedValue
        prevValue = wrappedValue
    }
    @ObservationIgnored
    public var wrappedValue: T {
        get {
            if value != prevValue {
                prevValue = value
                didChange = true
            } else {
                didChange = false
            }
            return value
        }
        set {
            value = newValue
        }
    }
}
