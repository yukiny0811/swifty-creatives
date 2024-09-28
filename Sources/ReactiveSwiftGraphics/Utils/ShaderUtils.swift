//
//  File.swift
//  SwiftyCreatives
//
//  Created by Yuki Kuwashima on 2024/09/21.
//

import MetalKit

internal enum ShaderUtils {
    static let device = MTLCreateSystemDefaultDevice()!
    static let textureLoader = MTKTextureLoader(device: device)
}
