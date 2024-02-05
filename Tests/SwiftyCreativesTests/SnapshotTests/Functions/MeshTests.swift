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
final class MeshTests: XCTestCase {
    
    @MainActor
    func testMeshIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let vertices: [f3] = [
                f3(-5, -5, -5),
                f3(5, 3, 5),
                f3(-5, 5, 3),
            ]
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                mesh(vertices, primitiveType: .triangle)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testMeshIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
