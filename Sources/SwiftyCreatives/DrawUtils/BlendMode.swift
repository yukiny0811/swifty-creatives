//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import Metal

// https://developer.apple.com/documentation/metal/mtlrenderpipelinecolorattachmentdescriptor
public enum BlendMode {
    case blend
    case add
    func setMode(descsriptor: MTLRenderPipelineDescriptor) {
        switch self {
        case .blend:
            descsriptor.colorAttachments[0].rgbBlendOperation = .add
            descsriptor.colorAttachments[0].alphaBlendOperation = .add
            descsriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceColor
            descsriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            descsriptor.colorAttachments[0].destinationRGBBlendFactor = .zero
            descsriptor.colorAttachments[0].destinationAlphaBlendFactor = .zero
        case .add:
            // FIXME: Add Blending Error
            descsriptor.colorAttachments[0].rgbBlendOperation = .add
            descsriptor.colorAttachments[0].alphaBlendOperation = .add
            descsriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            descsriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            descsriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            descsriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        }
    }
}
