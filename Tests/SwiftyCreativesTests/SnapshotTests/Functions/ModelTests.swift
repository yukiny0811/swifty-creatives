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
final class ModelTests: XCTestCase {
    
    @MainActor
    func testModelIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let modelObject = ModelObject().loadModel(name: "SampleObject", extensionName: "obj", bundle: .module).setScale(f3.one * 10)
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                rotateY(0.5)
                rotateZ(0.5)
                model(modelObject)
                
                scale(1.1)
                color(1)
                model(modelObject, primitiveType: .lineStrip)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testModelIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testModelIsDrawedWithTexture() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let modelObject = ModelObject().loadModel(name: "SampleObjectWithTexture", extensionName: "obj", bundle: .module).setScale(f3.one * 10)
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                rotateY(0.5)
                rotateZ(0.5)
                model(modelObject)
                
                scale(1.1)
                color(1)
                model(modelObject, primitiveType: .lineStrip)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testModelIsDrawedWithTexture")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testModelIsDrawedWithCustomTexture() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let modelObject = ModelObject().loadModel(name: "SampleObject", extensionName: "obj", bundle: .module).setScale(f3.one * 10)
            override func draw(encoder: SCEncoder) {
                color(1, 0, 1, 1)
                rotateY(0.5)
                rotateZ(0.5)
                model(
                    modelObject,
                    with: Bundle.module.image(
                        forResource: "sampleImage"
                    )!.cgImage(
                        forProposedRect: nil,
                        context: nil,
                        hints: nil
                    )!
                )
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testModelIsDrawedWithCustomTexture")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
