//
//  AssetUtil.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit

class AssetUtil {
    private static let defaultMTLTextureDescriptor: MTLTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
        pixelFormat: MTLPixelFormat.bgra8Unorm,
        width: 1,
        height: 1,
        mipmapped: false
    )
    static let defaultMTLTexture: MTLTexture = ShaderCore.device.makeTexture(
        descriptor: defaultMTLTextureDescriptor
    )!
}
