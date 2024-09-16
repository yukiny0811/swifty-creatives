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
        resolveGroup(group: entity)
        isTapping = false
    }

    private func resolveGroup(group: Group) {
        for e in group.entities {
            pushMatrix()
            if e is Empty {
                continue
            }
            if let e = e as? Group {
                resolveGroup(group: e)
            }
            push {

                translate(e.position)
                rotateX(e.rotation.x)
                rotateY(e.rotation.y)
                rotateZ(e.rotation.z)
                scale(e.scale)
                e.customRender(functions: HasSketchFunctions.self, encoder: encoder, customMatrix: &customMatrix, ray: currentRay)

                if let hasColliderEntity = e as? (any HasCollider), let currentRay, hasColliderEntity.rayInteractionEnabled {
                    let didCollide = hasColliderEntity.collider.didCollide(ray: currentRay, mat: getCustomMatrix())
                    if didCollide && hasColliderEntity.currentlyHovering == false {
                        hasColliderEntity.setHovering(true)
                    }
                    if didCollide && isTapping {
                        hasColliderEntity.tapProcess?()
                    }
                    if didCollide == false && hasColliderEntity.currentlyHovering {
                        hasColliderEntity.setHovering(false)
                    }
                }
            }

            if let childGroup = e.entity as? Group {
                resolveGroup(group: childGroup)
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
