//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/03.
//

import AVFoundation
import Accelerate

@available(macOS 14.0, *)
public class DetailedAudioCapturer: NSObject, AudioCapturer {
    
    public var fftResult: [FFTResultComponent] = []
    public var fftNoiseExtractionMethod: FFTNoiseExtractionMethod
    public var fftWindowType: TempiFFTWindowType
    public var fftMinFreq: Float
    public var fftMaxFreq: Float
    public var bandCalculationMethod: FFTBandCalculationMethod = .linear(256)
    
    private let engine = AVAudioEngine()
    private let engineQueue = DispatchQueue(label: "SCAudioEngineQueue" + UUID().uuidString)
    
    public init(
        noiseExtractionMethod: FFTNoiseExtractionMethod = .none,
        fftWindowType: TempiFFTWindowType = .hanning,
        fftMinFreq: Float = 100,
        fftMaxFreq: Float = 30000
    ) {
        self.fftNoiseExtractionMethod = noiseExtractionMethod
        self.fftWindowType = fftWindowType
        self.fftMinFreq = fftMinFreq
        self.fftMaxFreq = fftMaxFreq
        super.init()
        
        let format = engine.inputNode.inputFormat(forBus: 0)
        print(format.sampleRate, format.commonFormat, format.settings)
        print(engine.inputNode.presentationLatency)
        engine.inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { [self] pcmBuffer, time in
            
            var floatArray = Array(UnsafeBufferPointer(start: pcmBuffer.floatChannelData?.pointee, count: Int(pcmBuffer.frameLength)))
            
            switch fftNoiseExtractionMethod {
            case .none:
                break
            case .freqDomain(let threshold):
                var timeDomainArray = floatArray.map { $0 }
                var freqDomainArray = floatArray.map { $0 }
                NoiseExtractor.extractSignalFromNoise(
                    sampleCount: floatArray.count,
                    noisySignal: floatArray,
                    threshold: threshold,
                    timeDomainDestination: &timeDomainArray,
                    frequencyDomainDestination: &freqDomainArray
                )
                floatArray = freqDomainArray
            case .timeDomain(let threshold):
                var timeDomainArray = floatArray.map { $0 }
                var freqDomainArray = floatArray.map { $0 }
                NoiseExtractor.extractSignalFromNoise(
                    sampleCount: floatArray.count,
                    noisySignal: floatArray,
                    threshold: threshold,
                    timeDomainDestination: &timeDomainArray,
                    frequencyDomainDestination: &freqDomainArray
                )
                floatArray = timeDomainArray
            }
            
            let fft = TempiFFT(withSize: floatArray.count, sampleRate: Float(pcmBuffer.format.sampleRate))

            // Setting a window type reduces errors
            fft.windowType = self.fftWindowType

            // Perform the FFT
            fft.fftForward(floatArray)

            switch bandCalculationMethod {
            case .linear(let bandCount):
                fft.calculateLinearBands(minFrequency: self.fftMinFreq, maxFrequency: self.fftMaxFreq, numberOfBands: bandCount)
            case .logarithmic(let bandsPerOctave):
                // Map FFT data to logical bands. This gives 4 bands per octave across 7 octaves = 28 bands.
                fft.calculateLogarithmicBands(minFrequency: self.fftMinFreq, maxFrequency: self.fftMaxFreq, bandsPerOctave: bandsPerOctave)
            }
            
            
            if fftResult.count != fft.numberOfBands {
                print(#line, #file)
                fftResult = []
            }
            
            // Process some data
            for i in 0..<fft.numberOfBands {
                let f = fft.frequencyAtBand(i)
                let m = fft.magnitudeAtBand(i)
                if fftResult.count-1 < i {
                    fftResult.append(FFTResultComponent(frequency: f, magnitude: m))
                } else {
                    fftResult[i] = FFTResultComponent(frequency: f, magnitude: m)
                }
            }
        }
    }
    
    public func start() {
        self.engine.prepare()
        engineQueue.async {
            try! self.engine.start()
        }
    }
    
    public func stop() {
        self.engine.stop()
    }
}
