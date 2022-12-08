//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Foundation

import Metal

public final class ShaderCore {
    public static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    public static var library: MTLLibrary = {
        return try! ShaderCore.device.makeDefaultLibrary(bundle: Bundle.module)
    }()
    public static var commandQueue: MTLCommandQueue = {
        return ShaderCore.device.makeCommandQueue()!
    }()
}
