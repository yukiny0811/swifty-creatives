//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/14.
//

import Foundation
import MetalKit

enum ShaderCore {
    static let rayTracingShaderLibrary = try! SwiftyCreatives.ShaderCore.device.makeDefaultLibrary(bundle: .module)
}
