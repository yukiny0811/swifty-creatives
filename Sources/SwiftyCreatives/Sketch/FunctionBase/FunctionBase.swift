//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/07.
//

import Metal

public protocol FunctionBase: AnyObject {
    var privateEncoder: SCEncoder? { get set }
    var customMatrix: [f4x4] { get set }
    var textPostProcessor: TextPostProcessor { get }
}
