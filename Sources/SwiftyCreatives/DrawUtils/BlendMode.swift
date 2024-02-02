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
    
    func getRenderer<
        D: DrawConfigBase
    >(sketch: SketchBase) -> RendererBase<D> {
        switch self {
        case .normalBlend:
            return NormalBlendRenderer<D>(sketch: sketch)
        case .add:
            if ShaderCore.device.supportsFamily(.apple3) {
                return AddRenderer<D>(sketch: sketch)
            } else {
                return NormalBlendRenderer<D>(sketch: sketch)
            }
        case .alphaBlend:
            if ShaderCore.device.supportsFamily(.apple4) {
                return TransparentRenderer<D>(sketch: sketch)
            } else {
                return NormalBlendRenderer<D>(sketch: sketch)
            }
        }
    }
}

#endif
