//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftyCreativesMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SketchObject.self
    ]
}
