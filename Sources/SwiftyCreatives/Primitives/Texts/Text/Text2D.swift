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
    public var finalVertices: [f3] = []
    public var finalVerticesNormalized: [f3] = []
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
        var largestX: Float = 0
        var largestY: Float = 0
        for vert in finalVertices {
            if vert.x > largestX {
                largestX = vert.x
            }
            if vert.y < largestY {
                largestY = vert.y
            }
        }
        finalVerticesNormalized = finalVertices.map { f3($0.x / largestX, $0.y / largestY, 0)}
        posBuffer = ShaderCore.device.makeBuffer(bytes: finalVertices, length: finalVertices.count * f3.memorySize)
    }
    public override init(
        text: String,
        fontName: String = "Avenir-BlackOblique",
        fontSize: Float = 10.0,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0,
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
