//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/07/06.
//

import AVFoundation
import Accelerate

#if os(macOS)

// probably 512 sample count
// read from any audio input
@available(macOS 14.0, *)
public class FastAudioCapturer: NSObject, AudioCapturer {
    
    private static let audioOutputSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVLinearPCMIsFloatKey: true,
        AVLinearPCMBitDepthKey: 32,
        AVNumberOfChannelsKey: 1
    ]
    
    private let captureSession = AVCaptureSession()
    private let captureQueue = DispatchQueue(label: "SCAudioQueue" + UUID().uuidString)
    
    public var fftResult: [FFTResultComponent] = []
    public var fftNoiseExtractionMethod: FFTNoiseExtractionMethod
    public var fftWindowType: TempiFFTWindowType
    public var fftMinFreq: Float
    public var fftMaxFreq: Float
    public var bandCalculationMethod: FFTBandCalculationMethod
    
    public convenience init(
        noiseExtractionMethod: FFTNoiseExtractionMethod = .none,
        fftWindowType: TempiFFTWindowType = .hanning,
        captureDeviceFindWithName deviceName: String,
        fftMinFreq: Float = 100,
        fftMaxFreq: Float = 30000,
        bandCalculationMethod: FFTBandCalculationMethod = .linear(256)
    ) {
        let captureDeviceDiscovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.microphone],
            mediaType: .audio,
            position: .unspecified
        )
        var searchedDevice: AVCaptureDevice?
        for device in captureDeviceDiscovery.devices {
            if device.localizedName.contains(deviceName) {
                searchedDevice = device
            }
        }
        if let searchedDevice = searchedDevice {
            self.init(noiseExtractionMethod: noiseExtractionMethod, fftWindowType: fftWindowType, captureDevice: searchedDevice, fftMinFreq: fftMinFreq, fftMaxFreq: fftMaxFreq, bandCalculationMethod: bandCalculationMethod)
        } else {
            print("Audio Capture Device \(deviceName) not found")
            self.init(noiseExtractionMethod: noiseExtractionMethod, fftWindowType: fftWindowType, fftMinFreq: fftMinFreq, fftMaxFreq: fftMaxFreq, bandCalculationMethod: bandCalculationMethod)
        }
    }
    
    public init(
        noiseExtractionMethod: FFTNoiseExtractionMethod = .none,
        fftWindowType: TempiFFTWindowType = .hanning,
        captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .audio),
        fftMinFreq: Float = 100,
        fftMaxFreq: Float = 30000,
        bandCalculationMethod: FFTBandCalculationMethod = .linear(512)
    ) {
        self.fftNoiseExtractionMethod = noiseExtractionMethod
        self.fftWindowType = fftWindowType
        self.fftMinFreq = fftMinFreq
        self.fftMaxFreq = fftMaxFreq
        self.bandCalculationMethod = bandCalculationMethod
        super.init()
        guard let captureDevice = captureDevice else { return }
        guard let audioInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("audio input creation failed")
            return
        }
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: captureQueue)
        audioOutput.audioSettings = Self.audioOutputSettings
        
        captureSession.beginConfiguration()
        captureSession.addInput(audioInput)
        captureSession.addOutput(audioOutput)
        captureSession.commitConfiguration()
    }
    
    public func start() {
        captureQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    public func stop() {
        self.captureSession.stopRunning()
    }
}

extension FastAudioCapturer: AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard connection.audioChannels.count > 0 else {
            print("audio channel not available")
            return
        }

        guard sampleBuffer.dataReadiness == .ready else {
            print("sampleBuffer not ready")
            return
        }

        let pcmBuffer = try? sampleBuffer.withAudioBufferList { audioBufferList, blockBuffer -> AVAudioPCMBuffer? in
            guard let asbd = sampleBuffer.formatDescription?.audioStreamBasicDescription else {
                print("asbd is nil")
                return nil
            }
            guard let format = AVAudioFormat(standardFormatWithSampleRate: asbd.mSampleRate, channels: asbd.mChannelsPerFrame) else {
                print("format is nil")
                return nil
            }
            return AVAudioPCMBuffer(pcmFormat: format, bufferListNoCopy: audioBufferList.unsafePointer)
        }

        guard let pcmBuffer = pcmBuffer else {
            print("pcmBuffer is nil")
            return
        }

        var floatArray = Array(UnsafeBufferPointer(start: pcmBuffer.floatChannelData?.pointee, count: Int(pcmBuffer.frameLength)))

        switch fftNoiseExtractionMethod {
        case .none:
            break
        case .freqDomain(let threshold):
            var timeDomainArray = floatArray.map { $0 }
            var freqDomainArray = floatArray.map { $0 }
            NoiseExtractor.extractSignalFromNoise(
                sampleCount: sampleBuffer.numSamples,
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
                sampleCount: sampleBuffer.numSamples,
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

#elseif os(iOS)

// probably 512 sample count
// read from any audio input
public class FastAudioCapturer: NSObject, AudioCapturer {
    
    private static let audioOutputSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVLinearPCMIsFloatKey: true,
        AVLinearPCMBitDepthKey: 32,
        AVNumberOfChannelsKey: 1
    ]
    
    private let captureSession = AVCaptureSession()
    private let captureQueue = DispatchQueue(label: "SCAudioQueue" + UUID().uuidString)
    
    public var fftResult: [FFTResultComponent] = []
    public var fftNoiseExtractionMethod: FFTNoiseExtractionMethod
    public var fftWindowType: TempiFFTWindowType
    public var fftMinFreq: Float
    public var fftMaxFreq: Float
    public var bandCalculationMethod: FFTBandCalculationMethod
    
    public convenience init(
        noiseExtractionMethod: FFTNoiseExtractionMethod = .none,
        fftWindowType: TempiFFTWindowType = .hanning,
        captureDeviceFindWithName deviceName: String,
        fftMinFreq: Float = 100,
        fftMaxFreq: Float = 30000,
        bandCalculationMethod: FFTBandCalculationMethod = .linear(256)
    ) {
        let captureDeviceDiscovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.microphone],
            mediaType: .audio,
            position: .unspecified
        )
        var searchedDevice: AVCaptureDevice?
        for device in captureDeviceDiscovery.devices {
            if device.localizedName.contains(deviceName) {
                searchedDevice = device
            }
        }
        if let searchedDevice = searchedDevice {
            self.init(noiseExtractionMethod: noiseExtractionMethod, fftWindowType: fftWindowType, captureDevice: searchedDevice, fftMinFreq: fftMinFreq, fftMaxFreq: fftMaxFreq, bandCalculationMethod: bandCalculationMethod)
        } else {
            print("Audio Capture Device \(deviceName) not found")
            self.init(noiseExtractionMethod: noiseExtractionMethod, fftWindowType: fftWindowType, fftMinFreq: fftMinFreq, fftMaxFreq: fftMaxFreq, bandCalculationMethod: bandCalculationMethod)
        }
    }
    
    public init(
        noiseExtractionMethod: FFTNoiseExtractionMethod = .none,
        fftWindowType: TempiFFTWindowType = .hanning,
        captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .audio),
        fftMinFreq: Float = 100,
        fftMaxFreq: Float = 30000,
        bandCalculationMethod: FFTBandCalculationMethod = .linear(256)
    ) {
        self.fftNoiseExtractionMethod = noiseExtractionMethod
        self.fftWindowType = fftWindowType
        self.fftMinFreq = fftMinFreq
        self.fftMaxFreq = fftMaxFreq
        self.bandCalculationMethod = bandCalculationMethod
        super.init()
        guard let captureDevice = captureDevice else { return }
        guard let audioInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("audio input creation failed")
            return
        }
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: captureQueue)
        
        captureSession.beginConfiguration()
        captureSession.addInput(audioInput)
        captureSession.addOutput(audioOutput)
        captureSession.commitConfiguration()
    }
    
    public func start() {
        captureQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    public func stop() {
        self.captureSession.stopRunning()
    }
}

extension FastAudioCapturer: AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard connection.audioChannels.count > 0 else {
            print("audio channel not available")
            return
        }

        guard sampleBuffer.dataReadiness == .ready else {
            print("sampleBuffer not ready")
            return
        }

        let pcmBuffer = try? sampleBuffer.withAudioBufferList { audioBufferList, blockBuffer -> AVAudioPCMBuffer? in
            guard let asbd = sampleBuffer.formatDescription?.audioStreamBasicDescription else {
                print("asbd is nil")
                return nil
            }
            guard let format = AVAudioFormat(standardFormatWithSampleRate: asbd.mSampleRate, channels: asbd.mChannelsPerFrame) else {
                print("format is nil")
                return nil
            }
            return AVAudioPCMBuffer(pcmFormat: format, bufferListNoCopy: audioBufferList.unsafePointer)
        }

        guard let pcmBuffer = pcmBuffer else {
            print("pcmBuffer is nil")
            return
        }

        var floatArray = Array(UnsafeBufferPointer(start: pcmBuffer.floatChannelData?.pointee, count: Int(pcmBuffer.frameLength)))

        switch fftNoiseExtractionMethod {
        case .none:
            break
        case .freqDomain(let threshold):
            var timeDomainArray = floatArray.map { $0 }
            var freqDomainArray = floatArray.map { $0 }
            NoiseExtractor.extractSignalFromNoise(
                sampleCount: sampleBuffer.numSamples,
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
                sampleCount: sampleBuffer.numSamples,
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

#endif
