//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/06.
//

import Foundation

public protocol AudioCapturer {
    var fftResult: [FFTResultComponent] { get set }
    var fftNoiseExtractionMethod: FFTNoiseExtractionMethod { get set }
    var fftWindowType: TempiFFTWindowType { get set }
    var fftMinFreq: Float { get set }
    var fftMaxFreq: Float { get set }
    var bandCalculationMethod: FFTBandCalculationMethod { get set }
    func start()
    func stop()
}
