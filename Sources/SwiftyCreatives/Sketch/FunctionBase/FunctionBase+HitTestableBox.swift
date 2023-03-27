//
//  FunctionBase+HitTestableBox.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/08.
//

import simd

public extension FunctionBase {
    func drawHitTestableBox(box: HitTestableBox) {
        privateEncoder?.setVertexBytes([f3.zero], length: f3.memorySize, index: VertexBufferIndex.ModelPos.rawValue)
        
        pushMatrix()
        
        pushMatrix()
        translate(0, 0, box.scale.z)
        box.front.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        translate(0, 0, -box.scale.z)
        box.back.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateY(Float.pi/2)
        translate(0, 0, box.scale.x)
        box.l.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateY(Float.pi/2)
        translate(0, 0, -box.scale.x)
        box.r.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateX(Float.pi/2)
        translate(0, 0, box.scale.y)
        box.top.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        pushMatrix()
        rotateX(Float.pi/2)
        translate(0, 0, -box.scale.y)
        box.bottom.drawWithCache(encoder: privateEncoder!, customMatrix: self.customMatrix.reduce(f4x4.createIdentity(), *))
        popMatrix()
        
        popMatrix()
    }
}
