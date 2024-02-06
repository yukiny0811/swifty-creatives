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
final class HitTestableImgTests: XCTestCase {
    
    @MainActor
    func testHitTestableImgIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let testImage = HitTestableImg().load(name: "sampleImage", bundle: .module).adjustScale(with: .basedOnWidth).multiplyScale(3)
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                rotateY(0.5)
                rotateZ(0.5)
                img(testImage)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testHitTestableImgIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
