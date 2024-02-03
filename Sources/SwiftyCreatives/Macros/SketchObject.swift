//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import Foundation

@attached(
    extension,
    conformances: FunctionBase, SketchObjectHasDraw,
    names: 
        named(privateEncoder),
        named(customMatrix)
)
@attached(
    member,
    conformances: FunctionBase, SketchObjectHasDraw,
    names: 
        named(privateEncoder),
        named(customMatrix)
)
public macro SketchObject() = #externalMacro(module: "SwiftyCreativesMacro", type: "SketchObject")
