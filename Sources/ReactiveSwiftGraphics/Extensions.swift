//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives
import SwiftUI

extension f2: VectorArithmetic, AdditiveArithmetic {
    public mutating func scale(by rhs: Double) {
        self *= Float(rhs)
    }
    public var magnitudeSquared: Double {
        simd_length_squared(simd_double2(self))
    }
}

extension f3: VectorArithmetic, AdditiveArithmetic {
    public mutating func scale(by rhs: Double) {
        self *= Float(rhs)
    }
    public var magnitudeSquared: Double {
        simd_length_squared(simd_double3(self))
    }
}

extension f4: VectorArithmetic, AdditiveArithmetic {
    public mutating func scale(by rhs: Double) {
        self *= Float(rhs)
    }
    public var magnitudeSquared: Double {
        simd_length_squared(simd_double4(self))
    }
}
