//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/04.
//

import Foundation

public class FFTVisualizer {
    
    public var baseUpOffset: Float = 20
    public var historyCount: Int = 5
    public var averageMags: [Float] = []
    public var freqArray: [Float] = []
    
    var magsHistory: [[Float]] = []
    
    public init() {}
    
    public func updateData(_ capturer: AudioCapturer) {
        
        let mags = capturer.fftResult.map {
            var db = TempiFFT.toDB($0.magnitude)
            if db.isNaN {
                db = 0
            }
            return db + baseUpOffset
        }
        freqArray = capturer.fftResult.map { $0.frequency }
        
        if averageMags.count != mags.count {
            averageMags = mags
            magsHistory = []
        }
        
        magsHistory.append(mags)
        while magsHistory.count > historyCount {
            magsHistory.removeFirst()
        }
        
        for i in 0..<averageMags.count {
            averageMags[i] = 0
        }
        
        for his in magsHistory {
            for i in 0..<his.count {
                averageMags[i] += his[i]
            }
        }
        
        for i in 0..<averageMags.count {
            averageMags[i] /= Float(magsHistory.count)
        }
    }
}
