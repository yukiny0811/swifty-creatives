//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/20.
//

import MetalKit
import CoreImage.CIFilterBuiltins

public struct TextObjectInfo: PrimitiveInfo {
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

public class TextObject: Primitive<TextObjectInfo> {
    private var texture: MTLTexture?
    
    #if os(macOS)
    public typealias FontAlias = NSFont
    public typealias ColorAlias = NSColor
    #elseif os(iOS)
    public typealias FontAlias = UIFont
    public typealias ColorAlias = UIColor
    #endif
    
    public func setText(_ text: String, font: FontAlias, color: ColorAlias) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let filter = CIFilter(
            name: "CIAttributedTextImageGenerator",
            parameters: [
                "inputText": attributedText,
                "inputScaleFactor": 3.0
            ]
        )!
            
        let outputImage = filter.outputImage!
        let loader = MTKTextureLoader(device: ShaderCore.device)
        let tex = try? loader.newTexture(cgImage: ShaderCore.context.createCGImage(outputImage, from: outputImage.extent)!)
        self.texture = tex
        
        let longer: Float = Float(max(outputImage.extent.width, outputImage.extent.height))
        self.setScale(
            f3(
                Float(outputImage.extent.width) / longer,
                Float(outputImage.extent.height) / longer,
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
}
