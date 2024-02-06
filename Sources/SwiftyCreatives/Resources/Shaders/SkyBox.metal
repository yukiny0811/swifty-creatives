#include <metal_stdlib>
using namespace metal;

#include "Functions.metal"

struct SkyboxVertexIn {
    float4 position [[ attribute(0) ]];
};

struct SkyboxVertexOut {
    float4 position [[ position ]];
    float3 texCoord;
};

vertex SkyboxVertexOut vertex_skybox(
    const SkyboxVertexIn vIn [[stage_in]],
    const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(VertexBuffer_ProjectionMatrix) ]],
    const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(VertexBuffer_ViewMatrix) ]]
) {
    SkyboxVertexOut out;
    float4x4 mat = uniformProjectionMatrix.value * uniformViewMatrix.value;
    out.position = (mat * vIn.position).xyww;
    out.texCoord = vIn.position.xyz;
    return out;
}

fragment half4 fragment_skybox(
    SkyboxVertexOut vIn [[ stage_in ]],
    texturecube<half> cubeTexture [[ texture(FragmentTexture_SkyBox) ]]
) {
    constexpr sampler default_sampler(filter::linear);
    half4 color = cubeTexture.sample(
        default_sampler,
        vIn.texCoord
    );
    return color;
}
