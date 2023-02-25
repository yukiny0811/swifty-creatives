//
//  BlendMode.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

public enum BlendMode {
    case normalBlend
    case add
    case alphaBlend
    
    func getRenderer<
        C: CameraConfigBase,
        D: DrawConfigBase
    >(c: C.Type, d: D.Type, sketch: SketchBase) -> RendererBase<C, D> {
        switch self {
        case .normalBlend:
            return NormalBlendRenderer<C, D>(sketch: sketch)
        case .add:
            if ShaderCore.device.supportsFamily(.apple3) {
                return AddRenderer<C, D>(sketch: sketch)
            } else {
                return NormalBlendRenderer<C, D>(sketch: sketch)
            }
        case .alphaBlend:
            if ShaderCore.device.supportsFamily(.apple4) {
                return TransparentRenderer<C, D>(sketch: sketch)
            } else {
                return NormalBlendRenderer<C, D>(sketch: sketch)
            }
        }
    }
}
