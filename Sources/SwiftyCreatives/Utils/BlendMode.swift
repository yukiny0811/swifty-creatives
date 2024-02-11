//
//  BlendMode.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

#if os(visionOS)

import CompositorServices

public extension RendererBase {
    enum BlendMode {
        
        case normalBlend
        case add
        case alphaBlend
        
        public func getRenderer(sketch: Sketch, layerRenderer: LayerRenderer) -> RendererBase {
            switch self {
            case .normalBlend:
                return NormalBlendRendererVision(sketch: sketch, layerRenderer: layerRenderer)
            case .add:
                if ShaderCore.device.supportsFamily(.apple3) {
                    return AddBlendRendererVision(sketch: sketch, layerRenderer: layerRenderer)
                } else {
                    return NormalBlendRendererVision(sketch: sketch, layerRenderer: layerRenderer)
                }
            case .alphaBlend:
                if ShaderCore.device.supportsFamily(.apple4) {
                    return TransparentRendererVision(sketch: sketch, layerRenderer: layerRenderer)
                } else {
                    return NormalBlendRendererVision(sketch: sketch, layerRenderer: layerRenderer)
                }
            }
        }
    }
}

#else

public extension RendererBase {
    
    enum BlendMode {
        
        case normalBlend
        case add
        case alphaBlend
        
        public func getRenderer(sketch: Sketch, cameraConfig: CameraConfig, drawConfig: DrawConfig) -> RendererBase {
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
}

#endif
