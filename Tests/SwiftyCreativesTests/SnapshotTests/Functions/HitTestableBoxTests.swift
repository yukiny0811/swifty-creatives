//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/05.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(macOS)
final class HitTestableBoxTests: XCTestCase {
    
    @MainActor
    func testHitTestableBoxIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let testBox = HitTestableBox().setScale(f3.one * 5)
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                rotateY(0.5)
                rotateZ(0.5)
                box(testBox)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testHitTestableBoxIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
