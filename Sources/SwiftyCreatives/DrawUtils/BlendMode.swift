//
//  BlendMode.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import Metal

public enum BlendMode {
    case normalBlend
    case add
    case alphaBlend
    
    func getRenderer<
        P: SketchBase,
        C: CameraConfigBase,
        D: DrawConfigBase
    >(p: P.Type, c: C.Type, d: D.Type) -> any RendererBase {
        switch self {
        case .normalBlend:
            return NormalBlendRenderer<P, C, D>()
        case .add:
            return AddRenderer<P, C, D>()
        case .alphaBlend:
            return TransparentRenderer<P, C, D>()
        }
    }
}
