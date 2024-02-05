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
final class TextTests: XCTestCase {
    
    @MainActor
    func testText2DIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let textObject = Text2D(text: "Test", fontName: "Avenir-BlackOblique", fontSize: 10)
            override func draw(encoder: SCEncoder) {
                color(0.3, 0.6, 1.0, 1.0)
                text(textObject)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testText2DIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testText3DIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let textObject = Text3D(text: "Test", fontName: "Avenir-BlackOblique", fontSize: 10, extrudingValue: 8)
            override func draw(encoder: SCEncoder) {
                color(0.3, 0.6, 1.0, 1.0)
                rotateY(0.5)
                text(textObject)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testText3DIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testText3DRawIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let buffer: MTLBuffer!
            let count: Int!
            override init(_ expectation: XCTestExpectation, testName: String) {
                let textObject = Text3DRaw(text: "Test", fontName: "Avenir-BlackOblique", fontSize: 10, extrudingValue: 8)
                buffer = ShaderCore.device.makeBuffer(bytes: textObject.finalVertices, length: textObject.finalVertices.count * f3.memorySize)
                count = textObject.finalVertices.count
                super.init(expectation, testName: testName)
            }
            override func draw(encoder: SCEncoder) {
                color(0.3, 0.6, 1.0, 1.0)
                rotateY(0.5)
                mesh(buffer, count: count, primitiveType: .line)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testText3DRawIsDrawed")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testTextFactoryIsWorking() async throws {
        try SnapshotTestUtil.testGPU()
        class TestSketch: SketchForTest {
            let factory = TextFactory(fontName: "Avenir-BlackOblique", fontSize: 5)
            override init(_ expectation: XCTestExpectation, testName: String) {
                super.init(expectation, testName: testName)
                for t in "Test !!" {
                    factory.cacheCharacter(char: t)
                }
            }
            override func draw(encoder: SCEncoder) {
                color(0.3, 0.6, 1.0, 1.0)
                text("Test !!", factory: factory)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation, testName: "testTextFactoryIsWorking")
        SnapshotTestUtil.render(sketch: sketch)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
