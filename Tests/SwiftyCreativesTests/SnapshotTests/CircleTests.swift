//
//  CircleTests.swift
//
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(macOS)
final class CircleTests: XCTestCase {
    
    @MainActor
    func testCircleIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1)
                circle(3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testCircleIsDrawed")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testCircleParameterWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1)
                circle(1, 1, 1, 2, 3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testCircleParameterWorking")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testCircleColorWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                circle(3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testCircleColorWorking")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
