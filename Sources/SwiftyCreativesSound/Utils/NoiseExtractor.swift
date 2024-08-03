//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/04.
//
//  original code from Apple, modified by Yuki Kuwashima
//
//  Copyright © 2023 Apple Inc.
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Accelerate

public enum NoiseExtractor {
    public static func extractSignalFromNoise(
        sampleCount: Int,
        noisySignal: [Float],
        threshold: Double,
        timeDomainDestination: inout [Float],
        frequencyDomainDestination: inout [Float]
    ) {
        guard let forwardDCTSetup = vDSP.DCT(
            count: sampleCount,
            transformType: vDSP.DCTTransformType.II
        ) else {
            return
        }
        guard let inverseDCTSetup = vDSP.DCT(
            count: sampleCount,
            transformType: vDSP.DCTTransformType.III
        ) else {
            return
        }
        
        forwardDCTSetup.transform(
            noisySignal,
            result: &frequencyDomainDestination
        )
        
        vDSP.threshold(
            frequencyDomainDestination,
            to: Float(threshold),
            with: .zeroFill,
            result: &frequencyDomainDestination
        )
        
        inverseDCTSetup.transform(
            frequencyDomainDestination,
            result: &timeDomainDestination
        )
        
        let divisor = Float(sampleCount / 2)
        
        vDSP.divide(
            timeDomainDestination,
            divisor,
            result: &timeDomainDestination
        )
    }
}
