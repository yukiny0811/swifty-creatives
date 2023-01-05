//
//  File.swift
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#include <metal_stdlib>
#include "Functions.metal"
using namespace metal;

vertex RasterizerData normal_vertex (const Vertex vIn [[ stage_in ]],
                                            const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(1) ]],
                                            const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(2) ]],
                                            const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(3) ]],
                                            const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(4) ]],
                                            const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(5) ]],
                                            const device FrameUniforms_CameraPos& uniformCameraPos [[ buffer(6) ]]
                                     ) {
    
    float4x4 modelMatrix = createModelMatrix(
                                             vIn,
                                             uniformModelPos,
                                             uniformModelRot,
                                             uniformModelScale,
                                             uniformProjectionMatrix,
                                             uniformViewMatrix
                                             );
            
    RasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = (modelMatrix * float4(vIn.normal, 1.0)).xyz;
    rd.toCameraVector = uniformCameraPos.value - rd.worldPosition;
    rd.position = uniformProjectionMatrix.value * uniformViewMatrix.value * modelMatrix * float4(vIn.position, 1.0);
    rd.color = vIn.color;
    rd.uv = vIn.uv;
    return rd;
}

fragment half4 normal_fragment (RasterizerData rd [[stage_in]],
                                const device Material &material [[ buffer(1) ]],
                                const device int &lightCount [[ buffer(2) ]],
                                const device Light *lights [[ buffer(3) ]],
                                const device FrameUniforms_HasTexture &uniformHasTexture [[ buffer(6) ]],
                                const device FrameUniforms_IsActiveToLight &isActiveToLight [[ buffer(7) ]],
                                texture2d<half> tex [[ texture(0) ]]) {
    
    half4 resultColor = half4(0, 0, 0, 0);
    
    if (uniformHasTexture.value) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        resultColor = tex.sample(textureSampler, float2(rd.uv.x*tex.get_width(), rd.uv.y*tex.get_height()));
    } else {
        resultColor = half4(rd.color.x, rd.color.y, rd.color.z, 1);
    }
    
    if (isActiveToLight.value) {
        float3 phongIntensity = calculatePhongIntensity(rd, material, lightCount, lights);
        resultColor = half4(float4(resultColor) * float4(phongIntensity, 1));
    }
    return resultColor;
}
