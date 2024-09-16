//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/17.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DrawFunction: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw "@DrawFunction has to be set to a function"
        }

        // should be access modifier
        var modifierString = ""
        for modifier in functionDecl.modifiers {
            if modifier.trimmedDescription == "static" { continue }
            modifierString += modifier.trimmedDescription + " "
        }

        // setModelPos
        var functionName = functionDecl.name.text
        var functionSignature = functionDecl.signature
        let parameters = functionSignature.parameterClause.parameters

        guard parameters[parameters.startIndex].trimmedDescription == "_ encoder: MTLRenderCommandEncoder?," || parameters[parameters.startIndex].trimmedDescription == "_ encoder: MTLRenderCommandEncoder?" else {
            throw "first parameter of function signature must be _ encoder: MTLRenderCommandEncoder?,"
        }

        //  _ value: f3
        var copyingParameterString = ""
        for parameter in parameters[parameters.index(at: 1)..<parameters.endIndex] {
            if parameter.trimmedDescription == "customMatrix: inout [f4x4]," || parameter.trimmedDescription == "customMatrix: inout [f4x4]" {
                continue
            }
            copyingParameterString += parameter.trimmedDescription + " "
        }

        guard let codeBlock = functionDecl.body else {
            throw "no code block (unknown error)"
        }
        let codeBlockString = codeBlock.trimmedDescription

        var resultString = ""
        resultString += modifierString + "func " + functionName + "(" + copyingParameterString + ")" + codeBlockString

        var resultDecl = DeclSyntax(stringLiteral: resultString)

        return [resultDecl]
    }
}
