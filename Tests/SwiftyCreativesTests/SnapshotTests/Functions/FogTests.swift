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
final class FogTests: XCTestCase {
    
    @MainActor
    func testFogIsWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            override func draw(encoder: SCEncoder) {
                setFog(color: f4(1, 0, 0, 1), density: 0.03)
                color(1)
                let count = 5
                rotateY(0.5)
                rotateZ(0.5)
                for x in -count...count {
                    for y in -count...count {
                        for z in -count...count {
                            box(
                                Float(x) * 10,
                                Float(y) * 10,
                                Float(z) * 10,
                                1,
                                1,
                                1
                            )
                        }
                    }
                }
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testFogIsWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif

