//
//  Feature2.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/08/03.
//

import SwiftyCreatives
import SwiftUI

final class Feature2: Sketch {

    enum TextSamples: Int {
        case textFactory
        case text2d
        case text3d
        case text3dRaw
        case textFactoryRaw
        case text2dPath
        mutating func toggleNext() {
            self = Self(rawValue: self.rawValue + 1) ?? Self(rawValue: 0)!
        }
    }

    var frameCount = 0
    var currentGeometry: TextSamples = TextSamples(rawValue: 0)!

    let text2d = Text2D(text: "Test")
    let text3d = Text3D(text: "Test3D", extrudingValue: 1)
    let factory: TextFactory = {
        let f = TextFactory()
        for c in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!?.," {
            f.cacheCharacter(char: c)
        }
        return f
    }()

    let text3dRaw = Text3DRaw(text: "Test3D", extrudingValue: 1)
    let factoryRaw: RawTextFactory = {
        let f = RawTextFactory()
        for c in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!?.," {
            f.cacheCharacter(char: c)
        }
        return f
    }()

    override func update(camera: MainCamera) {
        frameCount += 1
        if frameCount.isMultiple(of: 300) {
            currentGeometry.toggleNext()
        }
    }

    override func draw(encoder: SCEncoder, camera: MainCamera) {
        color(1, 1, 1, 1)

        switch currentGeometry {
        case .textFactory:
            text("Hello, World!", factory: factory)
        case .text2d:
            text(text2d)
        case .text3d:
            text(text3d)
        case .text3dRaw:
            for blob in text3dRaw.chunkedBlobs {
                mesh(blob.map { $0 + f3.randomPoint(0...0.3) }, primitiveType: .lineStrip)
            }
        case .textFactoryRaw:
            if let vertices = factoryRaw.cached["H"]?.vertices.map({ f3($0) }) {
                mesh(vertices: vertices, colors: vertices.map { _ in f4.randomPoint(0.5...1) }, primitiveType: .triangle)
            }
            break
        case .text2dPath:
            let str = text2d.calculatedPaths.map { $0.glyphs }
            if let letter = str.first {
                for line in letter {
                    mesh(line.map { f3(Float($0.x), Float($0.y), 0) }, primitiveType: .lineStrip)
                }
            }
        }
    }

    struct VIEW: View {
        var body: some View {
            VStack {
                Text("text geometries")
                SketchView(Feature2())
            }
        }
    }
}
