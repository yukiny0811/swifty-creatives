//
//  TextObject.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/20.
//

import MetalKit
import CoreImage.CIFilterBuiltins
import CoreGraphics

open class TextObject: RectanglePlanePrimitive<RectShapeInfo> {
    private var texture: MTLTexture?
    
    public override init() {
        super.init()
        hasTexture = [true]
    }
    
    func createParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return paragraphStyle
    }
    
    func createAttributedString(text: String, font: FontAlias, color: ColorAlias, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    func createFramesetterFrame(framesetter: CTFramesetter, framePath: CGPath) -> CTFrame {
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), framePath, nil)
        return frame
    }
    
    @discardableResult
    public func setDetailedText(_ text: String, font: FontAlias, color: ColorAlias, resolution: CGSize, framePath: CGPath? = nil) -> Self {
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: MTLPixelFormat.rgba8Unorm,
            width: Int(resolution.width),
            height: Int(resolution.height),
            mipmapped: false)
        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        texture = ShaderCore.device.makeTexture(descriptor: textureDescriptor)!
        
        #if os(iOS)
        UIGraphicsBeginImageContextWithOptions(resolution, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return self }
        ctx.translateBy(x: 0, y: resolution.height)
        ctx.scaleBy(x: 1, y: -1)
        #elseif os(macOS)
        let gContext = NSGraphicsContext.init(bitmapImageRep: NSBitmapImageRep(ciImage: CIImage(mtlTexture: texture!)!))!
        let ctx = gContext.cgContext
        #endif
        let paragraphStyle = createParagraphStyle()
        let attributedString = createAttributedString(text: text, font: font, color: color, paragraphStyle: paragraphStyle)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        if let framePath = framePath {
            let framesetterFrame = createFramesetterFrame(framesetter: framesetter, framePath: framePath)
            CTFrameDraw(framesetterFrame, ctx)
        } else {
            let defaultRect = CGRect(origin: .zero, size: resolution)
            let rectPath = CGPath(rect: defaultRect, transform: nil)
            let framesetterFrame = createFramesetterFrame(framesetter: framesetter, framePath: rectPath)
            CTFrameDraw(framesetterFrame, ctx)
        }
        
        #if os(iOS)
        UIGraphicsEndImageContext()
        #endif
        
        let im = ctx.makeImage()!
        let tex = try! ShaderCore.textureLoader.newTexture(cgImage: im)
        self.texture = tex
        
        let longer: Float = Float(max(im.width, im.height))
        self.setScale(f3(
            Float(im.width) / longer,
            Float(im.height) / longer,
            1
        ))
        return self
    }
    
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
    public override func draw(_ encoder: SCEncoder) {
        encoder.setVertexBytes(RectShapeInfo.vertices, length: RectShapeInfo.vertices.count * f3.memorySize, index: VertexBufferIndex.Position.rawValue)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: VertexBufferIndex.ModelScale.rawValue)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: VertexBufferIndex.Color.rawValue)
        encoder.setVertexBytes(RectShapeInfo.uvs, length: RectShapeInfo.uvs.count * f2.memorySize, index: VertexBufferIndex.UV.rawValue)
        encoder.setVertexBytes(RectShapeInfo.normals, length: RectShapeInfo.normals.count * f3.memorySize, index: VertexBufferIndex.Normal.rawValue)
        encoder.setFragmentBytes([true], length: Bool.memorySize, index: FragmentBufferIndex.HasTexture.rawValue)
        encoder.setFragmentTexture(self.texture, index: FragmentTextureIndex.MainTexture.rawValue)
        encoder.drawPrimitives(type: RectShapeInfo.primitiveType, vertexStart: 0, vertexCount: RectShapeInfo.vertices.count)
    }
}
