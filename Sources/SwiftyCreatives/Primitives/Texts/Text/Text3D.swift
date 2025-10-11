//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import Metal
import CoreText
import SimpleSimdSwift
import FontVertexBuilder

open class Text3D: PathText {
    public var posBuffer: MTLBuffer?
    public var finalVertices: [f3] = []
    public var extrudingIndices: [Int] = []
    private var extrudingValue: Float = 0
    public func extrude(_ value: Float) {
        for i in extrudingIndices {
            finalVertices[i].z += value
        }
        posBuffer?.contents().copyMemory(from: finalVertices, byteCount: f3.memorySize * finalVertices.count)
    }
    func createAndSetBuffer(from triangulatedPaths: [TriangulatedLetterPath]) throws {
        finalVertices = []
        extrudingIndices = []
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                finalVertices += portion.map { f3($0) }
            }
        }
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                for i in 0..<portion.count {
                    extrudingIndices.append(finalVertices.count+i)
                }
                finalVertices += portion.map { f3($0) + f3(0, 0, extrudingValue) }
            }
        }
        for path in calculatedPaths {
            for glyph in path.glyphs {
                for i in 0..<glyph.count {
                    if i != glyph.count - 1 {
                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[i+1].x), Float(glyph[i+1].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        finalVertices.append(f3(Float(glyph[i+1].x), Float(glyph[i+1].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[i+1].x), Float(glyph[i+1].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))
                    } else {
                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[0].x), Float(glyph[0].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        finalVertices.append(f3(Float(glyph[i].x), Float(glyph[i].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        finalVertices.append(f3(Float(glyph[0].x), Float(glyph[0].y), 0) + f3(Float(path.offset.x), Float(path.offset.y), 0))

                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(Float(glyph[0].x), Float(glyph[0].y), extrudingValue) + f3(Float(path.offset.x), Float(path.offset.y), 0))
                    }
                }
            }
        }
        if finalVertices.count == 0 {
            throw TextBufferCreationError.noVertices
        }
        posBuffer = ShaderCore.device.makeBuffer(bytes: finalVertices, length: f3.memorySize * finalVertices.count)
    }
    public init(
        text: String,
        fontName: String = "Avenir-BlackOblique",
        fontSize: Float = 10.0,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0,
        extrudingValue: Float = 0,
        maxDepth: Int = 1
    ) {
        self.extrudingValue = extrudingValue
        super.init(
            text: text,
            fontName: fontName,
            fontSize: Double(fontSize),
            bounds: bounds,
            pivot: simd_double2(pivot),
            textAlignment: textAlignment,
            verticalAlignment: verticalAlignment,
            kern: Double(kern),
            lineSpacing: Double(lineSpacing),
            maxDepth: maxDepth
        )
        let triangulatedPaths = GlyphUtil.MainFunctions.triangulate(self.calculatedPaths)
        try? createAndSetBuffer(from: triangulatedPaths)
    }
}

