//
//  AssetUtil.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/19.
//

import MetalKit

class AssetUtil {
    static let defaultMTLTexture: MTLTexture = try! ShaderCore.textureLoader.newTexture(
        name: "mtl-default",
        scaleFactor: 1,
        bundle: .module,
        options: [
            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
            .textureStorageMode : NSNumber(value: MTLStorageMode.private.rawValue)
        ]
    )
}
