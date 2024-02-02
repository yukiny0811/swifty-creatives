//
//  BlendMode.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

#if !os(visionOS)

public enum BlendMode {
    
    case normalBlend
    case add
    case alphaBlend
    
    func getRenderer(sketch: SketchBase, cameraConfig: CameraConfig, drawConfig: DrawConfig) -> RendererBase {
        switch self {
        case .normalBlend:
            return NormalBlendRenderer(sketch: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
        case .add:
            if ShaderCore.device.supportsFamily(.apple3) {
                return AddRenderer(sketch: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
            } else {
                return NormalBlendRenderer(sketch: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
            }
        case .alphaBlend:
            if ShaderCore.device.supportsFamily(.apple4) {
                return TransparentRenderer(sketch: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
            } else {
                return NormalBlendRenderer(sketch: sketch, cameraConfig: cameraConfig, drawConfig: drawConfig)
            }
        }
    }
}

#endif
