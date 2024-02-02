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
    private(set) public var originalTexture: MTLTexture?
    private(set) public var texture: MTLTexture?
    private var textPostProcessor = TextPostProcessor()
    
    @discardableResult
    public func setColor(commandBuffer: MTLCommandBuffer, _ value: f4) -> Self {
        textPostProcessor.postProcessColor(commandBuffer: commandBuffer, originalTexture: originalTexture!, texture: self.texture!, color: value)
        return self
    }
    
    @discardableResult
    public func setColor(commandBuffer: MTLCommandBuffer, _ r: Float, _ g: Float, _ b: Float, _ a: Float) -> Self {
        textPostProcessor.postProcessColor(commandBuffer: commandBuffer, originalTexture: originalTexture!, texture: self.texture!, color: f4(r, g, b, a))
        return self
    }
    
    public override init() {
        super.init()
    }
    
    private func createParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return paragraphStyle
    }
    
    private func createAttributedString(text: String, font: FontAlias, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: ColorAlias.white,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    private func createFramesetterFrame(framesetter: CTFramesetter, framePath: CGPath) -> CTFrame {
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), framePath, nil)
        return frame
    }
    
    @discardableResult
    public func setDetailedText(_ text: String, font: FontAlias, resolution: CGSize, framePath: CGPath? = nil) -> Self {
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: MTLPixelFormat.bgra8Unorm,
            width: Int(resolution.width),
            height: Int(resolution.height),
            mipmapped: false)
        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        originalTexture = ShaderCore.device.makeTexture(descriptor: textureDescriptor)!
        #if os(iOS) || os(visionOS)
        UIGraphicsBeginImageContextWithOptions(resolution, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return self }
        ctx.translateBy(x: 0, y: resolution.height)
        ctx.scaleBy(x: 1, y: -1)
        #elseif os(macOS)
        let gContext = NSGraphicsContext.init(bitmapImageRep: NSBitmapImageRep(ciImage: CIImage(mtlTexture: originalTexture!)!))!
        let ctx = gContext.cgContext
        #endif
        let paragraphStyle = createParagraphStyle()
        let attributedString = createAttributedString(text: text, font: font, paragraphStyle: paragraphStyle)
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
        originalTexture = try! ShaderCore.textureLoader.newTexture(
            cgImage: im,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        self.texture = originalTexture
        
        let longer: Float = Float(max(im.width, im.height))
        self.setScale(f3(
            Float(im.width) / longer,
            Float(im.height) / longer,
            1
        ))
        return self
    }
    
    @discardableResult
    public func setText(_ text: String, font: FontAlias) -> Self {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: ColorAlias.white,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let filter = CIFilter.attributedTextImageGenerator()
        filter.text = attributedText
        filter.scaleFactor = 3.0
        
        let outputImage = filter.outputImage!
        originalTexture = try! ShaderCore.textureLoader.newTexture(
            cgImage: ShaderCore.context.createCGImage(outputImage, from: outputImage.extent)!,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        self.texture = originalTexture
        
        let longer: Float = Float(max(outputImage.extent.width, outputImage.extent.height))
        
        self.setScale(f3(
            Float(outputImage.extent.width) / longer,
            Float(outputImage.extent.height) / longer,
            1
        ))
        return self
    }
    
    @available(*, unavailable, message: "Use text() in Sketch instead.")
    public override func draw(_ encoder: SCEncoder) {}
}
