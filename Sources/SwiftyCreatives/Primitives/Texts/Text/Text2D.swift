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

open class Text2D: PathText {
    public var posBuffer: MTLBuffer?
    public var finalVertices: [simd_double3] = []
    public var finalVerticesNormalized: [simd_double3] = []
    func createAndSetBuffer(from triangulatedPaths: [TriangulatedLetterPath]) throws {
        finalVertices = []
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                finalVertices += portion
            }
        }
        if finalVertices.count == 0 {
            throw TextBufferCreationError.noVertices
        }
        var largestX: Double = 0
        var largestY: Double = 0
        for vert in finalVertices {
            if vert.x > largestX {
                largestX = vert.x
            }
            if vert.y < largestY {
                largestY = vert.y
            }
        }
        finalVerticesNormalized = finalVertices.map { simd_double3($0.x / largestX, $0.y / largestY, 0)}
        posBuffer = ShaderCore.device.makeBuffer(
            bytes: finalVertices.map { f3($0) },
            length: finalVertices.count * f3.memorySize
        )
    }
    public override init(
        text: String,
        fontName: String = "Avenir-BlackOblique",
        fontSize: Double = 10.0,
        bounds: CGSize = .zero,
        pivot: simd_double2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Double = 0.0,
        lineSpacing: Double = 0.0,
        maxDepth: Int = 1
    ) {
        super.init(
            text: text,
            fontName: fontName,
            fontSize: fontSize,
            bounds: bounds,
            pivot: pivot,
            textAlignment: textAlignment,
            verticalAlignment: verticalAlignment,
            kern: kern,
            lineSpacing: lineSpacing,
            maxDepth: maxDepth
        )
        let triangulatedPaths = GlyphUtil.MainFunctions.triangulate(self.calculatedPaths)
        try? createAndSetBuffer(from: triangulatedPaths)
    }
}
