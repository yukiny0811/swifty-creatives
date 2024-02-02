//
//  GeneralTextFactory.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import MetalKit
import CoreGraphics

public class GeneralImageTextFactory: ImageTextFactory {
    public override init(font: FontAlias, register characters: String, color: ColorAlias) {
        let registeringCharacters = Self.validateCharacters(characters: characters)
        super.init(font: font, register: registeringCharacters, color: color)
    }
    private static func validateCharacters(characters: String) -> String {
        return String(characters.compactMap { $0 != " " ? $0 : nil })
    }
}
