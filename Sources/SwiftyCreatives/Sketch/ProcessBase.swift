//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/08.
//

import Metal

public protocol ProcessBase {
    init()
    func setup()
    func update()
    func cameraProcess(camera: MainCamera<some CameraConfigBase>)
    func draw(encoder: MTLRenderCommandEncoder)
}
