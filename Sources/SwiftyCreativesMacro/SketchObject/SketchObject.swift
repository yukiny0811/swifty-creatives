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

public struct SketchObject {}

extension SketchObject: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        if protocols.isEmpty { return [] }
        
        let thisExtension1: DeclSyntax =
        """
        extension \(type.trimmed): FunctionBase {}
        """
        
        let thisExtension2: DeclSyntax =
        """
        extension \(type.trimmed): SketchObjectHasDraw {}
        """
        
        guard let extensionDecl1 = thisExtension1.as(ExtensionDeclSyntax.self) else {
            return []
        }
        guard let extensionDecl2 = thisExtension2.as(ExtensionDeclSyntax.self) else {
            return []
        }
        
        return [extensionDecl1, extensionDecl2]
    }
}

extension SketchObject: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if protocols.isEmpty { return [] }
        
        let thisDecl1: DeclSyntax =
        """
        public var privateEncoder: SCEncoder?
        """
        
        let thisDecl2: DeclSyntax =
        """
        public var customMatrix: [f4x4] = []
        """
        
        return [thisDecl1, thisDecl2]
    }
    
}
