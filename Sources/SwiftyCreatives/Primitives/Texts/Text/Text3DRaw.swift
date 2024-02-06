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

fileprivate extension [f3] {
    func chunks(ofCount c: Int) -> [[f3]] {
        var finalResult: [[f3]] = []
        var index = 0
        var temp: [f3] = []
        for value in self {
            temp.append(value)
            index += 1
            if index % c == 0 {
                finalResult.append(temp)
                temp = []
            }
        }
        if temp.count > 0 {
            finalResult.append(temp)
        }
        return finalResult
    }
}

open class Text3DRaw: PathText {
    public var finalVertices: [f3] = []
    public var extrudingIndices: [Int] = []
    private(set) public var extrudingValue: Float = 0
    
    public var chunkedBlobs: [[f3]] = []
    
    func updateChunks() {
        chunkedBlobs = finalVertices.chunks(ofCount: 24)
    }
    
    public func extrude(_ value: Float) {
        extrudingValue += value
        for i in extrudingIndices {
            finalVertices[i].z += value
        }
        updateChunks()
    }
    func createAndSetBuffer(from triangulatedPaths: [TriangulatedLetterPath]) {
        finalVertices = []
        extrudingIndices = []
        
        var tempFinalVertices: [f3] = []
        for letter in triangulatedPaths {
            for portion in letter.glyphLines {
                tempFinalVertices += portion
            }
        }
        for i in 0..<tempFinalVertices.count {
            if i.isMultiple(of: 3) {
                finalVertices.append(tempFinalVertices[i])
                finalVertices.append(tempFinalVertices[i+1])
                finalVertices.append(tempFinalVertices[i+2])
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i] + f3(0, 0, extrudingValue))
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i+1] + f3(0, 0, extrudingValue))
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i+2] + f3(0, 0, extrudingValue))
            }
            if i.isMultiple(of: 3) || (i-1).isMultiple(of: 3) {
                finalVertices.append(tempFinalVertices[i])
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i] + f3(0, 0, extrudingValue))
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i+1] + f3(0, 0, extrudingValue))
                
                finalVertices.append(tempFinalVertices[i])
                
                finalVertices.append(tempFinalVertices[i+1])
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i+1] + f3(0, 0, extrudingValue))
            } else {
                finalVertices.append(tempFinalVertices[i])
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i] + f3(0, 0, extrudingValue))
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i-2] + f3(0, 0, extrudingValue))
                
                finalVertices.append(tempFinalVertices[i])
                
                finalVertices.append(tempFinalVertices[i-2])
                
                extrudingIndices.append(finalVertices.count)
                finalVertices.append(tempFinalVertices[i-2] + f3(0, 0, extrudingValue))
            }
        }
        updateChunks()
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
        extrudingValue: Float = 0
    ) {
        self.extrudingValue = extrudingValue
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
        createAndSetBuffer(from: triangulatedPaths)
    }
}
