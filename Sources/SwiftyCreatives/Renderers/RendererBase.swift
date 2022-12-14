//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

import MetalKit

protocol RendererBase: MTKViewDelegate {
    associatedtype Camera: MainCameraBase
    var camera: Camera { get }
}
