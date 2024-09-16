//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import Foundation
import SwiftUI

@propertyWrapper
@Observable
public class GraphicsStateAnimatable<T: VectorArithmetic>: Equatable {

    public static func == (lhs: GraphicsStateAnimatable<T>, rhs: GraphicsStateAnimatable<T>) -> Bool {
        lhs.value == rhs.value
    }

    @ObservationIgnored
    var task: Task<Void, any Error>?
    var value: T

    @ObservationIgnored
    public var projectedValue: GraphicsStateAnimatable { self }
    public init (wrappedValue: T) {
        value = wrappedValue
    }
    @ObservationIgnored
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    public func animate(to endValue: T, duration: Float, easingType: EasingFunctions = .ease_in_out_quad, complection: (() -> ())? = nil) {
        animation(
            target: self,
            keyPath: \.value,
            to: endValue,
            duration: duration,
            easingType: easingType,
            completion: complection
        )
    }

    func animation<Root>(
        target: Root,
        keyPath: ReferenceWritableKeyPath<Root, T>,
        to endValue: T,
        duration: Float,
        easingType: EasingFunctions = .ease_in_out_quad,
        completion: (() -> ())? = nil
    ) {
        self.task?.cancel()
        let waitingTime120fps: Double = 1.0 / 120.0 * 1000.0
        let startValue = target[keyPath: keyPath]
        let startTime = Date()

        let task = Task { @MainActor in
            while true {
                try await Task.sleep(for: .milliseconds(waitingTime120fps))
                let elapsed = Float(Date().timeIntervalSince(startTime))
                let elapsedNormalized = elapsed / duration
                target[keyPath: keyPath] = easingType.getEasingValue(start: startValue, end: endValue, currentElapsedLinearTime: Double(elapsedNormalized))
                if elapsedNormalized > 1.0 {
                    break
                }
            }
            completion?()
        }
        self.task = task
    }
}
