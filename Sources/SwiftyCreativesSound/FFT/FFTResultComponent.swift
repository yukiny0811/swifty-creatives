//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/04.
//

import Foundation

public struct FFTResultComponent {

    public var frequency: Float
    public var magnitude: Float

    public init(frequency: Float, magnitude: Float) {
        self.frequency = frequency
        self.magnitude = magnitude
    }
}
