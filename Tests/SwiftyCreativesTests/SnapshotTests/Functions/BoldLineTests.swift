//
//  BoldLineTests.swift
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
final class BoldLineTests: XCTestCase {
    
    @MainActor
    func testBoldLineIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1)
                boldline(0, 0, 0, 10, 10, 10, width: 5)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoldLineIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoldLineColorWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                boldline(0, 0, 0, 10, 10, 10, width: 5)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoldLineColorWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoldLineVariations() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                boldline(0, 0, 0, 10, 10, 0, width: 2)
                boldline(0, 0, 0, 10, 0, 0, width: 2)
                boldline(-3, -4, 0, -3, 1, 0, width: 2)
                boldline(-5, -3, 0, 2, -5, 0, width: 2)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoldLineVariations")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoldLineWithVertexColor() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                boldline(0, 0, 0, 10, 10, 0, width: 2, color1: f4(1, 0, 0, 1), color2: f4(0, 0, 1, 1))
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testBoldLineWithVertexColor")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
