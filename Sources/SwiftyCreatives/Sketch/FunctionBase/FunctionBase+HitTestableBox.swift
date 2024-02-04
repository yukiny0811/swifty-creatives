//
//  FunctionBase+HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd
import SimpleSimdSwift

public extension FunctionBase {
    func box(_ hitTestableBox: HitTestableBox) {
        setUniforms(modelPos: .zero, modelScale: .one, hasTexture: false)
        
        push {
            push {
                translate(0, 0, hitTestableBox.scale.z)
                hitTestableBox.front.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                translate(0, 0, -hitTestableBox.scale.z)
                hitTestableBox.back.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateY(Float.pi/2)
                translate(0, 0, hitTestableBox.scale.x)
                hitTestableBox.l.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateY(Float.pi/2)
                translate(0, 0, -hitTestableBox.scale.x)
                hitTestableBox.r.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateX(Float.pi/2)
                translate(0, 0, hitTestableBox.scale.y)
                hitTestableBox.top.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
            push {
                rotateX(Float.pi/2)
                translate(0, 0, -hitTestableBox.scale.y)
                hitTestableBox.bottom.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
            }
        }
    }
}
