//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

#if os(iOS)

import MetalKit
import UIKit

public struct UIViewObjectInfo: PrimitiveInfo {
    public static var vertices: [f3] = [
        Self.VertexPoint.A,
        Self.VertexPoint.B,
        Self.VertexPoint.D,
        Self.VertexPoint.C
    ]
    
    public static var uvs: [f2] = [
        f2(0, 0),
        f2(0, 1),
        f2(1, 0),
        f2(1, 1)
    ]
    
    public static var normals: [f3] = [
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1),
        f3(0, 0, 1)
    ]
    
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   0.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   0.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   0.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   0.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangleStrip
}

public class UIViewObject: HitTestablePrimitive<UIViewObjectInfo> {
    private var texture: MTLTexture?
    
    public var viewObj: UIView?
    
    public required init() {
        super.init()
        hasTexture = [true]
    }
    
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
        encoder.setVertexBytes(UIViewObjectInfo.vertices, length: UIViewObjectInfo.vertices.count * f3.memorySize, index: 0)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 1)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 3)
        encoder.setFragmentBytes(self.hasTexture, length: MemoryLayout<Bool>.stride, index: 6)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 10)
        
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 10)
        encoder.setVertexBytes(UIViewObjectInfo.uvs, length: UIViewObjectInfo.uvs.count * f2.memorySize, index: 11)
        encoder.setVertexBytes(UIViewObjectInfo.normals, length: UIViewObjectInfo.normals.count * f3.memorySize, index: 12)
        
        encoder.setFragmentTexture(self.texture, index: 0)
        encoder.drawPrimitives(type: UIViewObjectInfo.primitiveType, vertexStart: 0, vertexCount: UIViewObjectInfo.vertices.count)
    }
    
    public func buttonTest(origin: f3, direction: f3, testDistance: Float = 3000) {
        guard let coord = hitTestGetNormalizedCoord(origin: origin, direction: direction, testDistance: testDistance) else {
            return
        }
        let viewCoord = CGPoint(
            x: (CGFloat(coord.x)+1.0) / 2,
            y: 1.0 - (CGFloat(coord.y)+1.0) / 2
        )
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
