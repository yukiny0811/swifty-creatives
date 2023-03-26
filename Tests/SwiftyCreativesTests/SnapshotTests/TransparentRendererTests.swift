//
//  TransparentRendererTests.swift
//
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(iOS)
final class TransparentRendererTests: XCTestCase {
    
    class TestDrawConfig: DrawConfigBase {
        static var contentScaleFactor: Int = 3
        static var blendMode: SwiftyCreatives.BlendMode = .alphaBlend
        static var clearOnUpdate: Bool = true
        static var frameRate: Int = 60
    }
    
    @MainActor
    func testTransparentRendering() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            let randomPositions: [f3] = [
                f3(1, 2, 3),
                f3(-1, 0, 3),
                f3(2, 2, 3),
                f3(1, -2, -3),
                f3(-1, 2, -3)
            ]
            let randomColors: [f4] = [
                f4(0.3, 0.7, 1, 0.3),
                f4(0.8, 0.1, 0.7, 0.7),
                f4(0.9, 0.3, 0.3, 1),
                f4(1, 0.7, 1, 0.2),
                f4(0.3, 1, 0.4, 0.9)
            ]
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func setupCamera(camera: some MainCameraBase) {
                camera.rotateAroundY(0.5)
                camera.rotateAroundX(0.5)
            }
            override func draw(encoder: SCEncoder) {
                for i in 0..<5 {
                    pushMatrix()
                    translate(randomPositions[i])
                    color(randomColors[i])
                    box(3)
                    popMatrix()
                }
            }
            override func afterCommit() {
                self.expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = ConfigurableSketchView<MainCameraConfig, TestDrawConfig>(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        wait(for: [expectation], timeout: 5.0)
        
        let cgimage = swiftuiView.renderer.cachedTexture!.cgImage!
        let finalimage = UIImage(cgImage: cgimage)
        assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording)
    }
}
#endif
