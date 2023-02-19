//
//  NumberTextFactory.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import MetalKit
import CoreImage.CIFilterBuiltins
import CoreGraphics

public class NumberTextFactory {
    
    // 0 1 2 3 4 5 6 7 8 9 .
    var numberTexture: [MTLTexture] = []
    var sizes: [f3] = []
    
    static let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    
    static let indexDictionary: [String: Int] = [
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        ".": 10
    ]
    
    #if os(macOS)
        public typealias FontAlias = NSFont
        public typealias ColorAlias = NSColor
    #elseif os(iOS)
        public typealias FontAlias = UIFont
        public typealias ColorAlias = UIColor
    #endif
    
    public init(font: FontAlias) {
        for n in Self.numbers {
            let attributedString = createAttributedString(character: n, font: font, color: .white)
            let characterImage = createCharacterImage(attributedString: attributedString)
            numberTexture.append(createCharacterTexture(image: characterImage))
            
            let longer: Float = Float(max(characterImage.extent.width, characterImage.extent.height))
            sizes.append(f3(Float(characterImage.extent.width) / longer, Float(characterImage.extent.height) / longer, 1))
        }
    }
    
    func createAttributedString(character: String, font: FontAlias, color: ColorAlias) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        return NSAttributedString(string: character, attributes: attributes)
    }
    
    func createCharacterImage(attributedString: NSAttributedString) -> CIImage {
        let filter = CIFilter(
            name: "CIAttributedTextImageGenerator",
            parameters: [
                "inputText": attributedString,
                "inputScaleFactor": 3.0
            ]
        )!
        return filter.outputImage!
    }
    
    func createCharacterTexture(image: CIImage) -> MTLTexture {
        return try! ShaderCore.textureLoader.newTexture(cgImage: ShaderCore.context.createCGImage(image, from: image.extent)!)
    }
}
