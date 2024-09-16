//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftUI

public enum EasingFunctions {
    case ease_linear
    static func ease_linear<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: currentElapsedLinearTime)
    }

    case ease_in_quad
    static func ease_in_quad<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: currentElapsedLinearTime * currentElapsedLinearTime)
    }

    case ease_out_quad
    static func ease_out_quad<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start - temp.scaled(by: currentElapsedLinearTime * (currentElapsedLinearTime - 2))
    }

    case ease_in_out_quad
    static func ease_in_out_quad<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        var t = currentElapsedLinearTime * 2
        let temp = end - start
        if t < 1 {
            return start + temp.scaled(by: 0.5 * t * t)
        } else {
            t -= 1
            return start - temp.scaled(by: 0.5 * (t * (t - 2) - 1))
        }
    }

    case ease_in_cubic
    static func ease_in_cubic<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: pow(currentElapsedLinearTime, 3))
    }

    case ease_out_cubic
    static func ease_out_cubic<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let t = currentElapsedLinearTime - 1
        let temp = end - start
        return start + temp.scaled(by: pow(t, 3) + 1)
    }

    case ease_in_out_cubic
    static func ease_in_out_cubic<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        var t = currentElapsedLinearTime * 2
        let temp = end - start
        if t < 1 {
            return start + temp.scaled(by: 0.5 * pow(t, 3))
        } else {
            t -= 2
            return start + temp.scaled(by: 0.5 * (pow(t, 3) + 2))
        }
    }

    case ease_in_quart
    static func ease_in_quart<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: pow(currentElapsedLinearTime, 4))
    }

    case ease_out_quart
    static func ease_out_quart<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let t = currentElapsedLinearTime - 1
        let temp = end - start
        return start - temp.scaled(by: pow(t, 4) - 1)
    }

    case ease_in_out_quart
    static func ease_in_out_quart<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        var t = currentElapsedLinearTime * 2
        let temp = end - start
        if t < 1 {
            return start + temp.scaled(by: 0.5 * pow(t, 4))
        } else {
            t -= 2
            return start + temp.scaled(by: -0.5 * (pow(t, 4) - 2))
        }
    }

    case ease_in_quint
    static func ease_in_quint<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: pow(currentElapsedLinearTime, 5))
    }

    case ease_out_quint
    static func ease_out_quint<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let t = currentElapsedLinearTime - 1
        let temp = end - start
        return start + temp.scaled(by: pow(t, 5) + 1)
    }

    case ease_in_out_quint
    static func ease_in_out_quint<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        var t = currentElapsedLinearTime * 2
        let temp = end - start
        if t < 1 {
            return start + temp.scaled(by: 0.5 * pow(t, 5))
        } else {
            t -= 2
            return start + temp.scaled(by: 0.5 * (pow(t, 5) + 2))
        }
    }

    case ease_in_sine
    static func ease_in_sine<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start - temp.scaled(by: cos(currentElapsedLinearTime * .pi / 2)) + temp
    }

    case ease_out_sine
    static func ease_out_sine<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start + temp.scaled(by: sin(currentElapsedLinearTime * .pi / 2))
    }

    case ease_in_out_sine
    static func ease_in_out_sine<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        let temp = end - start
        return start - temp.scaled(by: 0.5 * (cos(.pi * currentElapsedLinearTime) - 1))
    }

    func getEasingValue<T: VectorArithmetic>(start: T, end: T, currentElapsedLinearTime: Double) -> T {
        switch self {
        case .ease_linear:
            Self.ease_linear(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_quad:
            Self.ease_in_quad(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_out_quad:
            Self.ease_out_quad(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_out_quad:
            Self.ease_in_out_quad(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_cubic:
            Self.ease_in_cubic(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_out_cubic:
            Self.ease_out_cubic(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_out_cubic:
            Self.ease_in_out_cubic(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_quart:
            Self.ease_in_quart(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_out_quart:
            Self.ease_out_quart(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_out_quart:
            Self.ease_in_out_quart(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_quint:
            Self.ease_in_quint(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_out_quint:
            Self.ease_out_quint(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_out_quint:
            Self.ease_in_out_quint(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_sine:
            Self.ease_in_sine(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_out_sine:
            Self.ease_out_sine(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        case .ease_in_out_sine:
            Self.ease_in_out_sine(start: start, end: end, currentElapsedLinearTime: currentElapsedLinearTime)
        }
    }
}
