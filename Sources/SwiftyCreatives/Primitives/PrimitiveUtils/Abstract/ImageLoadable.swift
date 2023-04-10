//
//  ImageLoadable.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

import Metal
import CoreGraphics

public protocol ImageLoadable: AnyObject, ScaleSettable {
    var texture: MTLTexture? { get set }
}

// MARK: Util Functions
public extension ImageLoadable {
    @discardableResult
    func adjustScale(with option: ImageAdjustOption) -> Self {
        let width = Float(texture!.width)
        let height = Float(texture!.height)
        switch option {
        case .basedOnWidth:
            self.setScale(f3(1, height / width, 1))
        case .basedOnHeight:
            self.setScale(f3(width / height, 1, 1))
        case .basedOnLonger:
            let longer = max(width, height)
            self.setScale(f3(width / longer, height / longer, 1))
        }
        return self
    }
}

// MARK: Load Functions
public extension ImageLoadable {
    
    @discardableResult
    func load(name: String, bundle: Bundle?) -> Self {
        self.texture = try! ShaderCore.textureLoader.newTexture(
            name: name,
            scaleFactor: 3,
            bundle: bundle,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
    
    @discardableResult
    func load(image: CGImage) -> Self {
        self.texture = try! ShaderCore.textureLoader.newTexture(
            cgImage: image,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
    
    @discardableResult
    func load(data: Data) -> Self {
        self.texture = try! ShaderCore.textureLoader.newTexture(
            data: data,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
}

// MARK: Async Load Functions
public extension ImageLoadable {
    
    @discardableResult
    func load(url: URL) async -> Self {
        self.texture = try! await ShaderCore.textureLoader.newTexture(
            URL: url,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
    
    @discardableResult
    func load(name: String, bundle: Bundle?) async -> Self {
        self.texture = try! await ShaderCore.textureLoader.newTexture(
            name: name,
            scaleFactor: 3,
            bundle: bundle,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
    
    @discardableResult
    func load(data: Data) async -> Self {
        self.texture = try! await ShaderCore.textureLoader.newTexture(
            data: data,
            options: ShaderCore.defaultTextureLoaderOptions
        )
        return self
    }
}
