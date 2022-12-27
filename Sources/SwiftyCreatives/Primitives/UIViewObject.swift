//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

#if os(iOS)

import MetalKit
import GLKit
import UIKit

public struct UIViewObjectInfo: PrimitiveInfo {
    private final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let bytes: [f3] = [
        VertexPoint.A,
        VertexPoint.B,
        VertexPoint.D,
        VertexPoint.C
    ]
    public static let vertexCount: Int = 4
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
    public static var hasTexture: [Bool] = [true]
}

public class UIViewObject: Primitive<UIViewObjectInfo> {
    private var texture: MTLTexture?
    
    private var viewObj: UIView?
    
    public func load(view: UIView) {
        
        self.viewObj = view
        
        let image = view.convertToImage().cgImage!
        
        let loader = MTKTextureLoader(device: ShaderCore.device)
        let tex = try! loader.newTexture(cgImage: image)
        self.texture = tex
        let longer: Float = Float(max(image.width, image.height))
        self.setScale(
            f3(
                Float(image.width) / longer,
                Float(image.height) / longer,
                1
            )
        )
    }
    override public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBytes(ImgInfo.bytes, length: ImgInfo.vertexCount * f3.memorySize, index: 0)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 1)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 3)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 4)
        encoder.setVertexBytes(ImgInfo.hasTexture, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.setFragmentBytes(ImgInfo.hasTexture, length: MemoryLayout<Bool>.stride, index: 7)
        encoder.setFragmentTexture(self.texture, index: 0)
        encoder.drawPrimitives(type: ImgInfo.primitiveType, vertexStart: 0, vertexCount: ImgInfo.vertexCount)
    }
    
    private func mockModel() -> GLKMatrix4 {
        let rotX = GLKMatrix4RotateX(GLKMatrix4Identity, self.rot.x)
        let rotY = GLKMatrix4RotateY(GLKMatrix4Identity, self.rot.y)
        let rotZ = GLKMatrix4RotateZ(GLKMatrix4Identity, self.rot.z)
        let trans = GLKMatrix4Translate(GLKMatrix4Identity, self.pos.x, self.pos.y, self.pos.z)
        let model = GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(trans, rotZ), rotY), rotX)
        return model
    }
    
    public func hitTestGetPos(origin: f3, direction: f3) -> f3? {
        let model = mockModel()

        let a = GLKMatrix4MultiplyVector4(model, GLKVector4(v: (0, 0, 1, 1)))

        let A = origin
        let B = origin + direction * 3000
        let n = simd_normalize(f3(a.x, a.y, a.z) - self.pos)
        let P = self.pos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        let inverseModel = GLKMatrix4Invert(model, nil)
        let inversedXVector = GLKMatrix4MultiplyVector4(inverseModel, GLKVector4(v: (x.x, x.y, x.z, 1)))
        let inversedX = f3(inversedXVector.x, inversedXVector.y, inversedXVector.z)
        
        let scaledPoint = self.scale
        
        guard -scaledPoint.x < inversedX.x && inversedX.x < scaledPoint.x &&
                -scaledPoint.y < inversedX.y && inversedX.y < scaledPoint.y else {
            return nil
        }
        
        return x
    }
    
    public func hitTestGetNormalizedCoord(origin: f3, direction: f3) -> f2? {
        let model = mockModel()

        let a = GLKMatrix4MultiplyVector4(model, GLKVector4(v: (0, 0, 1, 1)))

        let A = origin
        let B = origin + direction * 3000
        let n = simd_normalize(f3(a.x, a.y, a.z) - self.pos)
        let P = self.pos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        let inverseModel = GLKMatrix4Invert(model, nil)
        let inversedXVector = GLKMatrix4MultiplyVector4(inverseModel, GLKVector4(v: (x.x, x.y, x.z, 1)))
        let inversedX = f3(inversedXVector.x, inversedXVector.y, inversedXVector.z)
        
        let scaledPoint = self.scale
        
        guard -scaledPoint.x < inversedX.x && inversedX.x < scaledPoint.x &&
                -scaledPoint.y < inversedX.y && inversedX.y < scaledPoint.y else {
            return nil
        }
        
        let inversedPointF2 = f2(inversedX.x / scaledPoint.x, inversedX.y / scaledPoint.y)
        
        return inversedPointF2
    }
    
    public func buttonTest(origin: f3, direction: f3) {
        guard let coord = hitTestGetNormalizedCoord(origin: origin, direction: direction) else {
            return
        }
        let viewCoord = CGPoint(
            x: (CGFloat(coord.x)+1.0) / 2,
            y: 1.0 - (CGFloat(coord.y)+1.0) / 2
        )
        print(viewCoord)
        let result = self.viewObj!.hitTest(CGPoint(
            x: viewCoord.x * self.viewObj!.bounds.width,
            y: viewCoord.y * self.viewObj!.bounds.height
        ), with: nil)
        guard let button = result as? UIButton else {
            return
        }
        button.sendActions(for: .touchUpInside)
    }
}

#endif
