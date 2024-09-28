//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives
import SwiftUI

public struct Box: ReactiveGraphicsEntity, HasCollider {

    public static func == (lhs: Box, rhs: Box) -> Bool {
        lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale && lhs.color == rhs.color
    }

    public var position: f3
    public var rotation: f3
    public var scale: f3 {
        didSet {
            collider = .box(xLength: scale.x, yLength: scale.y, zLength: scale.z)
        }
    }
    public var color: f4
    public var collider: Collider = .sphere(radius: 0)
    public var rayInteractionEnabled = false
    public var hoverStatusChangeProcess: ((_ hoverStatus: Bool) -> ())?
    public var tapProcess: (() -> ())?
    @GraphicsState public var currentlyHovering = false

    public init(position: f3 = .zero, rotation: f3 = .zero, scale: f3 = .one, color: f4 = .one, currentlyHovering: Bool = false) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.color = color
        self.collider = .box(xLength: scale.x, yLength: scale.y, zLength: scale.z)
        self.currentlyHovering = currentlyHovering
    }

    public var entity: some ReactiveGraphicsEntity {
        Empty()
    }

    public func customRender(
        functions: HasSketchFunctions.Type,
        encoder: MTLRenderCommandEncoder?,
        vertexDescriptor: MTLVertexDescriptor?,
        customMatrix: inout [f4x4],
        ray: (origin: f3, direction: f3)?
    ) {
        functions.color(encoder, color)
        functions.box(encoder, 1)
    }

    public func enableRayInteraction() -> Self {
        var modifiedSelf = self
        modifiedSelf.rayInteractionEnabled = true
        return modifiedSelf
    }

    public func disableRayInteraction() -> Self {
        var modifiedSelf = self
        modifiedSelf.rayInteractionEnabled = false
        return modifiedSelf
    }

    public func onTap(process: (() -> ())?) -> Self {
        var modifiedSelf = self
        modifiedSelf.tapProcess = process
        return modifiedSelf
    }

    public func hovering(_ currentlyHovering: GraphicsState<Bool>) -> Self {
        var modifiedSelf: Box = self
        modifiedSelf._currentlyHovering = currentlyHovering
        return modifiedSelf
    }

    public func setHovering(_ hovering: Bool) {
        currentlyHovering = hovering
    }
}
