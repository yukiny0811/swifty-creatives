//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import Foundation

@resultBuilder
public struct ReactiveGraphicsBuilder {
    public static func buildBlock(_ component: some ReactiveGraphicsEntity) -> some ReactiveGraphicsEntity {
        component
    }
    public static func buildBlock(_ components: any ReactiveGraphicsEntity...) -> [any ReactiveGraphicsEntity] {
        components
    }
    public static func buildBlock(_ components: any ReactiveGraphicsEntity...) -> some ReactiveGraphicsEntity {
        Group { components }
    }
    public static func buildBlock(_ components: [any ReactiveGraphicsEntity]) -> [any ReactiveGraphicsEntity] {
        components
    }
    public static func buildArray(_ components: [any ReactiveGraphicsEntity]) -> [any ReactiveGraphicsEntity] {
        components
    }
    public static func buildArray(_ components: [[any ReactiveGraphicsEntity]]) -> [any ReactiveGraphicsEntity] {
        components.map{v in Group{v}}
    }
    public static func buildOptional(_ component: [any ReactiveGraphicsEntity]?) -> any ReactiveGraphicsEntity {
        if let c = component {
            return Group { c }
        } else {
            return Empty()
        }
    }
    public static func buildEither(first components: [any ReactiveGraphicsEntity]) -> any ReactiveGraphicsEntity {
        Group { components }
    }
    public static func buildEither(second components: [any ReactiveGraphicsEntity]) -> any ReactiveGraphicsEntity {
        Group { components }
    }
    public static func buildPartialBlock(first: [any ReactiveGraphicsEntity]) -> any ReactiveGraphicsEntity {
        Group { first }
    }
}
