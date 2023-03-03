//
//  UIViewObject.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

#if os(iOS)

import MetalKit
import UIKit

open class UIViewObject: RectanglePlanePrimitive<RectShapeInfo> {
    private(set) public var texture: MTLTexture?
    
    public var viewObj: UIView?
    
    public override init() {
        super.init()
        hasTexture = [true]
    }
    
    @discardableResult
    public func load(view: UIView) -> Self {
        
        self.viewObj = view
        
        let image = view.convertToImage().cgImage!
        
        let tex = try! ShaderCore.textureLoader.newTexture(
            cgImage: image,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        self.texture = tex
        let longer: Float = Float(max(image.width, image.height))
        self.setScale(
            f3(
                Float(image.width) / longer,
                Float(image.height) / longer,
                1
            )
        )
        return self
    }
    override public func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes(self.hasTexture, length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentTexture(self.texture, index: FragmentTextureIndex.MainTexture.rawValue)
        encoder.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
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
