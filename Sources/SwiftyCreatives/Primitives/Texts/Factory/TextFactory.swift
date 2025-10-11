//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import Foundation
import CoreText
import CoreGraphics
import Metal
import SimpleSimdSwift
import FontVertexBuilder

public class TextFactory {
    
    private var fontName: String
    private var fontSize: Double
    private var bounds: CGSize
    private var pivot: simd_double2
    private var textAlignment: CTTextAlignment
    private var verticalAlignment: PathText.VerticalAlignment
    private var kern: Double
    private var lineSpacing: Double
    private var isClockwiseFont: Bool
    
    public var cached: [Character: LetterCache] = [:]
    
    public func cacheCharacter(char: Character) {
        if char == " " { return }
        let vectorText = PathText(text: String(char), fontName: fontName, fontSize: fontSize, bounds: bounds, pivot: pivot, textAlignment: textAlignment, verticalAlignment: verticalAlignment, kern: kern, lineSpacing: lineSpacing)
        let resultTuple = GlyphUtil.MainFunctions.triangulateWithoutLetterOffset(vectorText.calculatedPaths)
        let path = resultTuple.paths.first!
        guard let offset = resultTuple.letterOffsets.first else {
            print("failed to cache \(char)")
            return
        }
        
        let characterPath = path.glyphLines.flatMap { $0.map { $0 + path.offset } }
        let pathBuffer = ShaderCore.device.makeBuffer(bytes: characterPath, length: characterPath.count * f3.memorySize)!
        cached[char] = LetterCache(
            buffer: pathBuffer,
            verticeCount: characterPath.count,
            offset: simd_double2(offset.x, offset.y),
            size: simd_double2(
                characterPath.max(by: {$0.x > $1.x})!.x,
                characterPath.max(by: {$0.y > $1.y})!.y
            )
        )
    }
    
    public init(fontName: String = "Avenir-BlackOblique",
                fontSize: Double = 10.0,
                bounds: CGSize = .zero,
                pivot: simd_double2 = .zero,
                textAlignment: CTTextAlignment = .natural,
                verticalAlignment: PathText.VerticalAlignment = .center,
                kern: Double = 0.0,
                lineSpacing: Double = 0.0,
                isClockwiseFont: Bool = true
    ) {
        self.fontName = fontName
        self.fontSize = fontSize
        self.bounds = bounds
        self.pivot = pivot
        self.textAlignment = textAlignment
        self.verticalAlignment = verticalAlignment
        self.kern = kern
        self.lineSpacing = lineSpacing
        self.isClockwiseFont = isClockwiseFont
    }
}
