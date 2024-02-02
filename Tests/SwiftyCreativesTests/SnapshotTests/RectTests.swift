//
//  RectTests.swift
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
final class RectTests: XCTestCase {
    
    @MainActor
    func testRectIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1)
                rect(3)
            }
            override func afterCommit() {
                self.expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
    
    @MainActor
    func testRectPosWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1)
                rect(1, 1, 1, 2, 3)
            }
            override func afterCommit() {
                self.expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
    
    @MainActor
    func testRectColorWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                rect(3)
            }
            override func afterCommit() {
                self.expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
}
#endif
