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
    func createAndSetBuffer(from triangulatedPaths: [TriangulatedLetterPath]) {
        finalVertices = []
        extrudingIndices = []
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                finalVertices += portion
            }
        }
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                for i in 0..<portion.count {
                    extrudingIndices.append(finalVertices.count+i)
                }
                finalVertices += portion.map { $0 + f3(0, 0, extrudingValue) }
            }
        }
        for path in calculatedPaths {
            for glyph in path.glyphs {
                for i in 0..<glyph.count {
                    if i != glyph.count - 1 {
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[i+1].x, glyph[i+1].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                        
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        finalVertices.append(f3(glyph[i+1].x, glyph[i+1].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[i+1].x, glyph[i+1].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                    } else {
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[0].x, glyph[0].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                        
                        finalVertices.append(f3(glyph[i].x, glyph[i].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        finalVertices.append(f3(glyph[0].x, glyph[0].y, 0) + f3(path.offset.x, path.offset.y, 0))
                        
                        extrudingIndices.append(finalVertices.count)
                        finalVertices.append(f3(glyph[0].x, glyph[0].y, extrudingValue) + f3(path.offset.x, path.offset.y, 0))
                    }
                }
            }
        }
        posBuffer = ShaderCore.device.makeBuffer(bytes: finalVertices, length: f3.memorySize * finalVertices.count)
    }
    public init(
        text: String,
        fontName: String = "AppleSDGothicNeo-Bold",
        fontSize: Float = 10.0,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0,
        extrudingValue: Float = 0
    ) {
        self.extrudingValue = extrudingValue
        super.init(text: text, fontName: fontName, fontSize: fontSize, bounds: bounds, pivot: pivot, textAlignment: textAlignment, verticalAlignment: verticalAlignment, kern: kern, lineSpacing: lineSpacing)
        let triangulatedPaths = GlyphUtil.MainFunctions.triangulate(self.calculatedPaths)
        createAndSetBuffer(from: triangulatedPaths)
    }
}

