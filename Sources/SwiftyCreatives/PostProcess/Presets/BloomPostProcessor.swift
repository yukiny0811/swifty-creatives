//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import EasyMetalShader
import MetalPerformanceShaders

@EMComputeShader
class BloomStep1 {
    
    @EMTextureArgument(.read)
    var tex: MTLTexture?
    
    @EMTextureArgument(.write)
    var texToApplyBlur: MTLTexture?
    
    var threshold: Float = 0.5
    
    var impl: String {
        """
        float4 color = tex.read(gid);
        float4 resultColor = float4(0, 0, 0, color.a);
        float currentIntensity = rgb2hsb(float3(color.r, color.g, color.b)).b;
        if (currentIntensity > threshold) {
            resultColor.rgb = color.rgb;
        }
        texToApplyBlur.write(resultColor, gid);
        """
    }
    
    var customMetalCode: String {
        """
        inline float3 rgb2hsb(float3 rgb) {
            float3 hsb;
                
            float maxC = max(max(rgb.r, rgb.g), rgb.b);
            float minC = min(min(rgb.r, rgb.g), rgb.b);
            float delta = maxC - minC;

            hsb.b = maxC;

            if (maxC != 0) {
                hsb.g = delta / maxC;
            } else {
                hsb.g = 0;
            }

            if (delta == 0) {
                hsb.r = 0;
            } else {
                if (rgb.r == maxC) {
                    hsb.r = (rgb.g - rgb.b) / delta;
                } else if (rgb.g == maxC) {
                    hsb.r = 2 + (rgb.b - rgb.r) / delta;
                } else if (rgb.b == maxC) {
                    hsb.r = 4 + (rgb.r - rgb.g) / delta;
                }
                hsb.r *= 60;
                if (hsb.r < 0) {
                    hsb.r += 360;
                }
            }
        
            hsb.r /= 360;
            
            return hsb;
        }
        """
    }
}

@EMComputeShader
class BloomStepFinal {
    
    var mainTexture: MTLTexture?
    
    @EMTextureArgument(.read)
    var imtermediateTexture: MTLTexture?
    
    var impl: String {
        """
        float4 color = mainTexture.read(gid);
        float4 bloomColor = imtermediateTexture.read(gid);
        float4 resultColor = float4(max(color.r, bloomColor.r), max(color.g, bloomColor.g), max(color.b, bloomColor.b), max(color.a, bloomColor.a));
        mainTexture.write(resultColor, gid);
        """
    }
    
    var customMetalCode: String {
        ""
    }
}

public class BloomPostProcessor {
    
    let step1 = BloomStep1()
    let stepFinal = BloomStepFinal()
    var intermediateTexture: MTLTexture!
    
    public init() {}
    
    public func dispatch(texture: MTLTexture, threshold: Float, intensity: Float, commandBuffer: MTLCommandBuffer) {
        
        if intermediateTexture == nil {
            intermediateTexture = EMMetalTexture.create(width: texture.width, height: texture.height, pixelFormat: texture.pixelFormat, label: nil)
        }
        
        if intermediateTexture.width != texture.width || intermediateTexture?.height != texture.height {
            intermediateTexture = EMMetalTexture.create(width: texture.width, height: texture.height, pixelFormat: texture.pixelFormat, label: nil)
        }
        
        let step1Encoder = commandBuffer.makeComputeCommandEncoder()!
        step1.tex = texture
        step1.texToApplyBlur = intermediateTexture
        step1.threshold = threshold
        step1.dispatch(step1Encoder, textureSizeReference: texture)
        step1Encoder.endEncoding()
        
        let blurFunc = MPSImageGaussianBlur(device: ShaderCore.device, sigma: intensity)
        blurFunc.encode(commandBuffer: commandBuffer, inPlaceTexture: &intermediateTexture)
        
        let finalStepEncoder = commandBuffer.makeComputeCommandEncoder()!
        stepFinal.mainTexture = texture
        stepFinal.imtermediateTexture = intermediateTexture
        stepFinal.dispatch(finalStepEncoder, textureSizeReference: texture)
        finalStepEncoder.endEncoding()
    }
    
    
}
