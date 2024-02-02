//
//  AddShader.metal
//
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

#include <metal_stdlib>
#include "Functions.metal"
using namespace metal;

vertex RasterizerData add_vertex (const Vertex vIn [[ stage_in ]],
                                  const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(VertexBuffer_ModelPos) ]],
                                  const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(VertexBuffer_ModelRot) ]],
                                  const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(VertexBuffer_ModelScale) ]],
                                  const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(VertexBuffer_ProjectionMatrix) ]],
                                  const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(VertexBuffer_ViewMatrix) ]],
                                  const device FrameUniforms_CameraPos& uniformCameraPos [[ buffer(VertexBuffer_CameraPos) ]],
                                  const device float4& color [[ buffer(VertexBuffer_Color) ]],
                                  const device FrameUniforms_CustomMatrix& uniformCustomMatrix [[ buffer(VertexBuffer_CustomMatrix) ]]
                                  ) {
            
    float4x4 modelMatrix = createModelMatrix(
                                             vIn,
                                             uniformModelPos,
                                             uniformModelRot,
                                             uniformModelScale,
                                             uniformProjectionMatrix,
                                             uniformViewMatrix,
                                             uniformCustomMatrix
                                             );
    
    RasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = (modelMatrix * float4(vIn.normal, 1.0)).xyz;
    rd.toCameraVector = uniformCameraPos.value - rd.worldPosition;
    rd.position = uniformProjectionMatrix.value * uniformViewMatrix.value * modelMatrix * float4(vIn.position, 1.0);
    rd.color = color;
    rd.uv = vIn.uv;
    return rd;
}

fragment half4 add_fragment (RasterizerData rd [[stage_in]],
                             half4 c [[color(0)]],
                             const device FrameUniforms_HasTexture &uniformHasTexture [[ buffer(FragmentBuffer_HasTexture) ]],
                             const device FrameUniforms_FogDensity &fogDensity [[ buffer(FragmentBuffer_FogDensity) ]],
                             const device FrameUniforms_FogColor &fogColor [[ buffer(FragmentBuffer_FogColor) ]],
                             texture2d<half, access::sample> tex [[ texture(FragmentTexture_MainTexture) ]]) {
    
    half4 resultColor = half4(0, 0, 0, 0);
    
    if (uniformHasTexture.value) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        const half4 colorSample = tex.sample(textureSampler, float2(rd.uv.x*tex.get_width(), rd.uv.y*tex.get_height()));
        resultColor = colorSample;
    } else {
        resultColor = half4(rd.color);
    }
    
    resultColor = half4(createFog(rd.position.z / rd.position.w,
                                    float4(resultColor),
                                    fogDensity.value,
                                    fogColor.value));
    
    return resultColor + c;
}
