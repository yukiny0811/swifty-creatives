//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/20.
//

import MetalKit
import CoreImage.CIFilterBuiltins

public struct TextObjectInfo: PrimitiveInfo {
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

public class TextObject: Primitive<TextObjectInfo> {
    private var texture: MTLTexture?
    
    public required init() {
        super.init()
        hasTexture = [true]
    }
    
#if os(macOS)
    public typealias FontAlias = NSFont
    public typealias ColorAlias = NSColor
#elseif os(iOS)
    public typealias FontAlias = UIFont
    public typealias ColorAlias = UIColor
#endif
    
    @discardableResult
    public func setText(_ text: String, font: FontAlias, color: ColorAlias) -> Self {
        
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
        let tex = try! loader.newTexture(cgImage: ShaderCore.context.createCGImage(outputImage, from: outputImage.extent)!)
        self.texture = tex
        
        let longer: Float = Float(max(outputImage.extent.width, outputImage.extent.height))
        
        self.setScale(f3(
            Float(outputImage.extent.width) / longer,
            Float(outputImage.extent.height) / longer,
            1
        ))
        return self 
    }
    public func draw(_ x: Float, _ y: Float, _ z: Float, _ encoder: SCEncoder) {
        encoder.setVertexBytes(TextObjectInfo.vertices, length: TextObjectInfo.vertices.count * f3.memorySize, index: 0)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 1)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 3)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 10)
        
        encoder.setVertexBytes(TextObjectInfo.uvs, length: TextObjectInfo.uvs.count * f2.memorySize, index: 11)
        encoder.setVertexBytes(TextObjectInfo.normals, length: TextObjectInfo.normals.count * f3.memorySize, index: 12)
        
        encoder.setFragmentBytes([true], length: MemoryLayout<Bool>.stride, index: 6)
        encoder.setFragmentTexture(self.texture, index: 0)
        encoder.drawPrimitives(type: TextObjectInfo.primitiveType, vertexStart: 0, vertexCount: TextObjectInfo.vertices.count)
        
        
        
    }
}
