//
//  MTLTexture+.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/26.
//

import Metal
import CoreGraphics
import CoreImage

public extension MTLTexture {
    var cgImage: CGImage? {
        guard let ciimage = CIImage(mtlTexture: self) else {
            return nil
        }
        let flipped = ciimage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        let cgimage = ShaderCore.context.createCGImage(
            flipped,
            from: flipped.extent
        )
        return cgimage
    }
}
