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
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                pushMatrix()
                translate(5, 0, 0)
                color(1)
                box(3)
                popMatrix()
                color(1, 0, 1)
                box(3)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testPushPopWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testNestedPushPopWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
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
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testNestedPushPopWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
