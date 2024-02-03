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

#if os(macOS)
final class TransparentRendererTests: XCTestCase {
    
    @MainActor
    func testTransparentRendering() async throws {
        try SnapshotTestUtil.testGPU()
        try XCTSkipIf(ShaderCore.device.supportsFamily(.apple3) == false)
        
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
            override func setupCamera(camera: MainCamera) {
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
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testTransparentRendering")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch, blendMode: .alphaBlend)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
