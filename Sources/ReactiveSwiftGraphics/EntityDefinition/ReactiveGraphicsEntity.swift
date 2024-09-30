//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import SwiftyCreatives

public protocol ReactiveGraphicsEntity: Equatable {

    var position: f3 { get set }
    var rotation: f3 { get set }
    var scale: f3 { get set }

    associatedtype RGEntity: ReactiveGraphicsEntity
    @ReactiveGraphicsBuilder var entity: RGEntity { get }

    func customRender(
        functions: HasSketchFunctions.Type,
        encoder: MTLRenderCommandEncoder?,
        customMatrix: inout [f4x4],
        ray: (origin: f3, direction: f3)?
    )
}

extension ReactiveGraphicsEntity where Self: Equatable {
    public func customRender(
        functions: HasSketchFunctions.Type,
        encoder: MTLRenderCommandEncoder?,
        customMatrix: inout [f4x4],
        ray: (origin: f3, direction: f3)?
    ) {}
    public func isEqual(to other: any ReactiveGraphicsEntity) -> Bool {
        if let otherEntity = other as? Self {
            return self == otherEntity
        }
        return false
    }
    public func onChange<T: Equatable>(of value: GraphicsState<T>, process: (() -> ())?) -> Self {
        if value.didChange {
            process?()
        }
        return self
    }
}
