//
//  GeneralTextFactory.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import MetalKit
import CoreImage.CIFilterBuiltins
import CoreGraphics

public class GeneralTextFactory {
    var registeredTextures: [String: (texture: MTLTexture, size: f3)] = [:]
    
    public init(font: FontAlias, register characters: String) {
        for c in characters {
            let str = String(c)
            let attributedString = createAttributedString(character: str, font: font, color: .white)
            let characterImage = createCharacterImage(attributedString: attributedString)
            let longer: Float = Float(max(characterImage.extent.width, characterImage.extent.height))
            registeredTextures[str] = (
                createCharacterTexture(image: characterImage),
                f3(Float(characterImage.extent.width) / longer, Float(characterImage.extent.height) / longer, 1)
            )
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
