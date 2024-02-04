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
        posBuffer = ShaderCore.device.makeBuffer(bytes: finalVertices, length: finalVertices.count * f3.memorySize)
    }
    public override init(
        text: String,
        fontName: String = "AppleSDGothicNeo-Bold",
        fontSize: Float = 10.0,
        bounds: CGSize = .zero,
        pivot: f2 = .zero,
        textAlignment: CTTextAlignment = .natural,
        verticalAlignment: PathText.VerticalAlignment = .center,
        kern: Float = 0.0,
        lineSpacing: Float = 0.0
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
            lineSpacing: lineSpacing
        )
        let triangulatedPaths = GlyphUtil.MainFunctions.triangulate(self.calculatedPaths)
        try? createAndSetBuffer(from: triangulatedPaths)
    }
}
