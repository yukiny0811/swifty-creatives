//
//  NormalShader.metal
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#include <metal_stdlib>
#include "Functions.metal"
using namespace metal;

struct TransparentFragOut {
    half4 color [[ color(0) ]];
    float depth [[ color(1) ]];
};

struct TransparentRasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 uv;
    float3 worldPosition;
    float3 surfaceNormal;
    float3 toCameraVector;
    uint layer [[render_target_array_index]];
};

fragment TransparentFragOut transparent_fragment (RasterizerData rd [[stage_in]],
                                half4 c0 [[ color(0) ]],
                                float depth [[ color(1) ]],
                                const device FrameUniforms_HasTexture &uniformHasTexture [[ buffer(FragmentBuffer_HasTexture) ]],
                                const device FrameUniforms_FogDensity &fogDensity [[ buffer(FragmentBuffer_FogDensity) ]],
                                const device FrameUniforms_FogColor &fogColor [[ buffer(FragmentBuffer_FogColor) ]],
                                texture2d<half, access::sample> tex [[ texture(FragmentTexture_MainTexture) ]]) {
    
    half4 resultColor = half4(0, 0, 0, 0);
    
    if (uniformHasTexture.value) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        resultColor = tex.sample(textureSampler, float2(rd.uv.x*tex.get_width(), rd.uv.y*tex.get_height()));
    } else {
        resultColor = half4(rd.color.x, rd.color.y, rd.color.z, rd.color.w);
    }
    
    resultColor = half4(createFog(rd.position.z / rd.position.w,
                                    float4(resultColor),
                                    fogDensity.value,
                                    fogColor.value));
    
    float currentDepth = rd.position.z;
    if (currentDepth > depth) {
        half4 tempResultColor = half4(0, 0, 0, 0);
        tempResultColor.a = c0.a * (1.0 - resultColor.a) + resultColor.a * 1.0;
        tempResultColor.r = (c0.a * (1.0 - resultColor.a) * c0.r + resultColor.a * 1.0 * resultColor.r);
        tempResultColor.g = (c0.a * (1.0 - resultColor.a) * c0.g + resultColor.a * 1.0 * resultColor.g);
        tempResultColor.b = (c0.a * (1.0 - resultColor.a) * c0.b + resultColor.a * 1.0 * resultColor.b);
        resultColor = tempResultColor;
    } else {
        half4 tempResultColor = half4(0, 0, 0, 0);
        tempResultColor.a = resultColor.a * (1.0 - c0.a) + c0.a * 1.0;
        tempResultColor.r = (resultColor.a * (1.0 - c0.a) * resultColor.r + c0.a * 1.0 * c0.r);
        tempResultColor.g = (resultColor.a * (1.0 - c0.a) * resultColor.g + c0.a * 1.0 * c0.g);
        tempResultColor.b = (resultColor.a * (1.0 - c0.a) * resultColor.b + c0.a * 1.0 * c0.b);
        resultColor = tempResultColor;
        
        currentDepth = depth;
    }
    
    TransparentFragOut out;
    out.color = resultColor;
    out.depth = currentDepth;
    return out;
}

vertex TransparentRasterizerData transparent_vertex_vision (const Vertex vIn [[ stage_in ]],
                                            const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(VertexBuffer_ModelPos) ]],
                                            const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(VertexBuffer_ModelRot) ]],
                                            const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(VertexBuffer_ModelScale) ]],
                                            const device FrameUniforms_ProjectionMatrix* uniformProjectionMatrix [[ buffer(VertexBuffer_ProjectionMatrix) ]],
                                            const device FrameUniforms_ViewMatrix* uniformViewMatrix [[ buffer(VertexBuffer_ViewMatrix) ]],
                                            const device FrameUniforms_CameraPos& uniformCameraPos [[ buffer(VertexBuffer_CameraPos) ]],
                                            const device float4& color [[ buffer(VertexBuffer_Color) ]],
                                            const device FrameUniforms_UseVertexColor& useVertexColor [[ buffer(VertexBuffer_UseVertexColor) ]],
                                            const device FrameUniforms_CustomMatrix& uniformCustomMatrix [[ buffer(VertexBuffer_CustomMatrix) ]],
                                            ushort amp_id [[amplification_id]]
                                     ) {
    
    float4x4 modelMatrix = createModelMatrix(
                                             vIn,
                                             uniformModelPos,
                                             uniformModelRot,
                                             uniformModelScale,
                                             uniformProjectionMatrix[amp_id],
                                             uniformViewMatrix[amp_id],
                                             uniformCustomMatrix
                                             );
            
    TransparentRasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = (modelMatrix * float4(vIn.normal, 1.0)).xyz;
    rd.toCameraVector = uniformCameraPos.value - rd.worldPosition;
    rd.position = uniformProjectionMatrix[amp_id].value * uniformViewMatrix[amp_id].value * modelMatrix * float4(vIn.position, 1.0);
    if (useVertexColor.value) {
        rd.color = vIn.color;
    } else {
        rd.color = color;
    }
    rd.uv = vIn.uv;
    
    return rd;
}
