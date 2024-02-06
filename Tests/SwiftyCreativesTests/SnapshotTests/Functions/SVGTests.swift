//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(macOS)
final class SVGTests: XCTestCase {
    
    @MainActor
    func testSVGIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        let svgObject = await SVGObj(url: Bundle.module.url(forResource: "sampleSvg", withExtension: "svg")!)!
        class TestSketch: SketchForTest {
            let svgObject: SVGObj
            init(svgObject: SVGObj, _ expectation: XCTestExpectation, testName: String) {
                self.svgObject = svgObject
                super.init(expectation, testName: testName)
            }
            override func draw(encoder: SCEncoder) {
                color(0.3, 0.6, 1.0, 1.0)
                scale(0.05)
                let count = svgObject.triangulated.reduce([], +).count
                var colors: [f4] = []
                for i in 0..<count {
                    colors.append(
                        f4(
                            1,
                            Float(i % 10) / 10,
                            Float(i % 17) / 17,
                            1
                        )
                    )
                }
                svg(svgObject, colors: colors)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                desc.pixelFormat = .bgra8Unorm
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 500, height: 500))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: testName)
            }
        }
        let expectation = XCTestExpectation()
        let sketch = TestSketch(svgObject: svgObject, expectation, testName: "testSVGIsDrawed")
        let swiftuiView = SketchView(sketch, blendMode: .normalBlend)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 500, height: 500), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif

