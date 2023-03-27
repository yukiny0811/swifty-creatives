//
//  PushPopTests.swift
//
//
//  Created by Yuki Kuwashima on 2023/03/28.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(macOS)
final class PushPopTests: XCTestCase {
    
    @MainActor
    func testPushPopWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                pushMatrix()
                translate(5, 0, 0)
                color(1)
                box(3)
                popMatrix()
                color(1, 0, 1)
                box(3)
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
        
        wait(for: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
    
    @MainActor
    func testNestedPushPopWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                pushMatrix()
                translate(5, 0, 0)
                color(1)
                box(3)
                pushMatrix()
                translate(0, 5, 0)
                color(1, 1, 0)
                box(3)
                popMatrix()
                popMatrix()
                color(1, 0, 1)
                box(3)
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
        
        wait(for: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
}
#endif
