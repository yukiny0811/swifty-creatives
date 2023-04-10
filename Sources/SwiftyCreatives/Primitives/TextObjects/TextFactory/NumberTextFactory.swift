//
//  NumberTextFactory.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import MetalKit
import CoreGraphics

public class NumberTextFactory: TextFactory {
    public init(font: FontAlias, color: ColorAlias) {
        super.init(font: font, register: TextFactory.Template.numerics, color: color)
    }
}
