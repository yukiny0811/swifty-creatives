//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import Foundation

public protocol HasCollider {
    var collider: Collider { get set }
    var rayInteractionEnabled: Bool { get set }
    var tapProcess: (() -> ())? { get set }
    var currentlyHovering: Bool { get set }
    associatedtype Parent: ReactiveGraphicsEntity
    func hovering(_ currentlyHovering: GraphicsState<Bool>) -> Parent
    func setHovering(_ hovering: Bool)
}
