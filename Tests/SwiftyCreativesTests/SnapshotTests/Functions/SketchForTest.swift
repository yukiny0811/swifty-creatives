//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

#if os(macOS)

@testable import SwiftyCreatives
import XCTest
import SnapshotTesting

class SketchForTest: Sketch {
    
    let expectation: XCTestExpectation
    let testName: String
    
    init(_ expectation: XCTestExpectation, testName: String) {
        self.expectation = expectation
        self.testName = testName
        super.init()
    }
    
    override func draw(encoder: SCEncoder) {}
    
    override func afterCommit(texture: MTLTexture?) {
        self.expectation.fulfill()
        let desc = MTLTextureDescriptor()
        desc.width = texture!.width
        desc.height = texture!.height
        desc.textureType = .type2D
        desc.pixelFormat = .bgra8Unorm
        let tex = ShaderCore.device.makeTexture(descriptor: desc)!
        
        let cb = ShaderCore.commandQueue.makeCommandBuffer()!
        let blitEncoder = cb.makeBlitCommandEncoder()!
        blitEncoder.copy(from: texture!, to: tex)
        blitEncoder.endEncoding()
        cb.commit()
        cb.waitUntilCompleted()
        
        let cgimage = tex.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: testName)
    }
}

#endif
