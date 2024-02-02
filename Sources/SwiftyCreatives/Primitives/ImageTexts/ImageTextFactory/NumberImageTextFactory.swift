//
//  NumberTextFactory.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import MetalKit
import CoreGraphics

public class NumberImageTextFactory: ImageTextFactory {
    public init(font: FontAlias, color: ColorAlias) {
        super.init(font: font, register: ImageTextFactory.Template.numerics, color: color)
    }
}
