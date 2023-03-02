//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import Foundation
import Metal
import CoreGraphics

public protocol ImageLoadable: AnyObject, ScaleSettable {
    var texture: MTLTexture? { get set }
}

public extension ImageLoadable {
    
    @discardableResult
    func configureScale(width: Float, height: Float) -> Self {
        let longer: Float = Float(max(width, height))
        self.setScale(
            f3(
                Float(texture!.width) / longer,
                Float(texture!.height) / longer,
                1
            )
        )
        return self
    }
    
    @discardableResult
    func load(name: String, bundle: Bundle?) -> Self {
        self.texture = try! ShaderCore.textureLoader.newTexture(name: name, scaleFactor: 3, bundle: bundle, options: [
            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue | MTLTextureUsage.shaderWrite.rawValue | MTLTextureUsage.renderTarget.rawValue)
        ])
        configureScale(width: Float(texture!.width), height: Float(texture!.height))
        return self
    }
    
    @discardableResult
    func loadAsync(url: URL) async -> Self {
        self.texture = try! await ShaderCore.textureLoader.newTexture(URL: url, options: [
            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue | MTLTextureUsage.shaderWrite.rawValue | MTLTextureUsage.renderTarget.rawValue)
        ])
        configureScale(width: Float(texture!.width), height: Float(texture!.height))
        return self
    }
    
    @discardableResult
    func loadAsync(name: String, bundle: Bundle?) async -> Self {
        self.texture = try! await ShaderCore.textureLoader.newTexture(name: name, scaleFactor: 3, bundle: bundle, options: [
                .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue | MTLTextureUsage.shaderWrite.rawValue | MTLTextureUsage.renderTarget.rawValue)
            ]
        )
        configureScale(width: Float(texture!.width), height: Float(texture!.height))
        return self
    }
    
    @discardableResult
    func load(image: CGImage) -> Self {
        self.texture = try! ShaderCore.textureLoader.newTexture(
            cgImage: image,
            options: [
                .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue | MTLTextureUsage.shaderWrite.rawValue | MTLTextureUsage.renderTarget.rawValue)
            ]
        )
        configureScale(width: Float(texture!.width), height: Float(texture!.height))
        return self
    }
}
