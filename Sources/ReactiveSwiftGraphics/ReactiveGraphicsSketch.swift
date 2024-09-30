//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives

public class ReactiveGraphicsSketch: Sketch, ObservableObject {

    @Published var entity: Group

    var currentRay: (origin: f3, direction: f3)?
    var isTapping = false

    public init(entity: Group) {
        self.entity = entity
    }

    public override func draw(encoder: any SCEncoder) {
        resolveGroup(group: entity, encoder: encoder)
        isTapping = false
    }

    private func resolveGroup(group: Group, encoder: MTLRenderCommandEncoder) {

        var collisionEntity: (any HasCollider)?
        var collisionMinDistance: Float = 999999

        for e in group.entities {
            pushMatrix()
            if e is Empty {
                continue
            }
            if let e = e as? Group {
                resolveGroup(group: e, encoder: encoder)
            }
            push {

                translate(e.position)
                rotateX(e.rotation.x)
                rotateY(e.rotation.y)
                rotateZ(e.rotation.z)
                scale(e.scale)
                e.customRender(functions: HasSketchFunctions.self, encoder: encoder, customMatrix: &customMatrix, ray: currentRay)

                if let hasColliderEntity = e as? (any HasCollider), let currentRay, hasColliderEntity.rayInteractionEnabled {
                    let collisionResult = hasColliderEntity.collider.didCollide(ray: currentRay, mat: getCustomMatrix())
                    if let collisionResult, hasColliderEntity.currentlyHovering == false {
                        hasColliderEntity.setHovering(true)
                    }
                    if let collisionResult, isTapping {
                        hasColliderEntity.tapProcess?()
                    }
                    if collisionResult == nil && hasColliderEntity.currentlyHovering {
                        hasColliderEntity.setHovering(false)
                    }
                }
            }

            if let childGroup = e.entity as? Group {
                resolveGroup(group: childGroup, encoder: encoder)
            }
            popMatrix()
        }
    }

    override public func mouseMoved(camera: MainCamera, location: f2) {
        let ray = camera.screenToWorldDirection(x: location.x, y: location.y)
        currentRay = ray
    }

    public override func mouseDown(camera: MainCamera, location: f2) {
        isTapping = true
    }

}
