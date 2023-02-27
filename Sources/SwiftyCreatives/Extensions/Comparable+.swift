//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

extension Comparable {
    func clamp(_ minValue: Self, _ maxValue: Self) -> Self {
        return min(max(minValue, self), maxValue)
    }
    func clamp(_ range: ClosedRange<Self>) -> Self {
        return self.clamp(range.lowerBound, range.upperBound)
    }
    static func clamp(value: Self, _ minValue: Self, _ maxValue: Self) -> Self {
        return min(max(minValue, value), maxValue)
    }
    static func clamp(value: Self, _ range: ClosedRange<Self>) -> Self {
        return value.clamp(range.lowerBound, range.upperBound)
    }
}
