//
//  FunctionBase+HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    func drawHitTestableBox(box: HitTestableBox) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        
        push {
            push {
                translate(0, 0, box.scale.z)
                box.front.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                translate(0, 0, -box.scale.z)
                box.back.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateY(Float.pi/2)
                translate(0, 0, box.scale.x)
                box.l.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateY(Float.pi/2)
                translate(0, 0, -box.scale.x)
                box.r.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateX(Float.pi/2)
                translate(0, 0, box.scale.y)
                box.top.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateX(Float.pi/2)
                translate(0, 0, -box.scale.y)
                box.bottom.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
        }
    }
}
