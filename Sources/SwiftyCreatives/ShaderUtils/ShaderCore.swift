//
//  ShaderCore.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal
import CoreImage

public final class ShaderCore {
    public static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    public static let library: MTLLibrary = {
        return try! ShaderCore.device.makeDefaultLibrary(bundle: Bundle.module)
    }()
    public static let commandQueue: MTLCommandQueue = {
        return ShaderCore.device.makeCommandQueue()!
    }()
    public static let context: CIContext = CIContext(mtlDevice: device)
}
