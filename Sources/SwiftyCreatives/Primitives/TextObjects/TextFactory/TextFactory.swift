//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/20.
//

import CoreImage

public class TextFactory {
    
    var registeredTextures: [String: TextFactory.TextureData] = [:]
    
    init(font: FontAlias, register characters: String) {
        for c in characters {
            let str = String(c)
            let attributedString = createAttributedString(character: str, font: font, color: .white)
            let characterImage = createCharacterImage(attributedString: attributedString)
            registeredTextures[str] = TextFactory.TextureData(
                texture: createCharacterTexture(image: characterImage),
                size: f3(Float(characterImage.extent.width / characterImage.extent.height), 1, 1)
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
        let filter = CIFilter.attributedTextImageGenerator()
        filter.text = attributedString
        filter.scaleFactor = 3.0
        return filter.outputImage!
    }
    
    func createCharacterTexture(image: CIImage) -> MTLTexture {
        return try! ShaderCore.textureLoader.newTexture(
            cgImage: ShaderCore.context.createCGImage(image, from: image.extent)!,
            options: ShaderCore.defaultTextureLoaderOptions
        )
    }
}
