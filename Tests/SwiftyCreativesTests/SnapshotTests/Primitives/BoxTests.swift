//
//  BoxTests.swift
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
final class BoxTests: XCTestCase {
    
    @MainActor
    func testBoxIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1)
                box(3)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoxIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoxColorWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                box(3)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoxColorWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoxRotationWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                rotateX(0.5)
                rotateY(0.5)
                box(3)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoxRotationWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
