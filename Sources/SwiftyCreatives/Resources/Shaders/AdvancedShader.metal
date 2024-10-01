//
//  File.metal
//  SwiftyCreatives
//
//  Created by Yuki Kuwashima on 2024/09/30.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
    float2 uv [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float4 color [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 uv;
    float3 worldPosition;
    float3 surfaceNormal;
    float3 toCameraVector;
    float size [[ point_size ]];
};

inline float4x4 createModelMatrix(
                                  const float3 modelPos,
                                  const float3 modelRot,
                                  const float3 modelScale
                                  ) {
    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                       float4(0.0, 1.0, 0.0, 0.0),
                                       float4(0.0, 0.0, 1.0, 0.0),
                                       float4(modelPos.x, modelPos.y, modelPos.z, 1.0));

    const float cosX = cos(modelRot.x);
    const float sinX = sin(modelRot.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                         float4(0.0, cosX, sinX, 0.0),
                                         float4(0.0, -sinX, cosX, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(modelRot.y);
    const float sinY = sin(modelRot.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, -sinY, 0.0),
                                         float4(0.0, 1.0, 0.0, 0.0),
                                         float4(sinY, 0.0, cosY, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(modelRot.z);
    const float sinZ = sin(modelRot.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, sinZ, 0.0, 0.0),
                                         float4(-sinZ, cosZ, 0.0, 0.0),
                                         float4(0.0, 0.0, 1.0, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    float4x4 modelScaleMatrix = float4x4(float4(modelScale.x, 0.0, 0.0, 0.0),
                                       float4(0.0, modelScale.y, 0.0, 0.0),
                                       float4(0.0, 0.0, modelScale.z, 0.0),
                                       float4(0.0, 0.0, 0.0, 1.0));

    float4x4 modelMatrix = modelTransMatrix * modelRotateZMatrix * modelRotateYMatrix * modelRotateXMatrix * modelScaleMatrix;
    return modelMatrix;
}

inline float4x4 createModelRotationMatrix(
                                  const float3 modelRot
                                  ) {

    const float cosX = cos(modelRot.x);
    const float sinX = sin(modelRot.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                         float4(0.0, cosX, sinX, 0.0),
                                         float4(0.0, -sinX, cosX, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(modelRot.y);
    const float sinY = sin(modelRot.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, -sinY, 0.0),
                                         float4(0.0, 1.0, 0.0, 0.0),
                                         float4(sinY, 0.0, cosY, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(modelRot.z);
    const float sinZ = sin(modelRot.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, sinZ, 0.0, 0.0),
                                         float4(-sinZ, cosZ, 0.0, 0.0),
                                         float4(0.0, 0.0, 1.0, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));

    float4x4 modelMatrix = modelRotateZMatrix * modelRotateYMatrix * modelRotateXMatrix;
    return modelMatrix;
}

vertex RasterizerData advanced_vertex (
                                       const Vertex vIn [[ stage_in ]],
                                       const device float3& modelPos [[ buffer(16) ]],
                                       const device float3& modelRot [[ buffer(17) ]],
                                       const device float3& modelScale [[ buffer(18) ]],
                                       const device float4x4& projectionMatrix [[ buffer(13) ]],
                                       const device float4x4& viewMatrix [[ buffer(14) ]],
                                       const device float3& cameraPos [[ buffer(15) ]]
                                       ) {

    float4x4 modelMatrix = createModelMatrix(
                                             modelPos,
                                             modelRot,
                                             modelScale
                                             );

    float4x4 modelRotationMatrix = createModelRotationMatrix(modelRot);

    RasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = normalize((modelRotationMatrix * float4(vIn.normal, 1.0)).xyz);
    rd.toCameraVector = cameraPos - rd.worldPosition;
    rd.position = projectionMatrix * viewMatrix * modelMatrix * float4(vIn.position, 1.0);
    rd.size = 1;
    rd.color = vIn.color;
    rd.uv = vIn.uv;
    return rd;
}

fragment half4 advanced_fragment (
                                  RasterizerData rd [[stage_in]],
                                  texture2d<half, access::sample> diffuseTex [[ texture(1) ]]
) {

    half4 resultColor = half4(0, 0, 0, 0);

    if (!is_null_texture(diffuseTex)) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        resultColor = diffuseTex.sample(textureSampler, float2(rd.uv.x*diffuseTex.get_width(), rd.uv.y*diffuseTex.get_height()));
    } else {
        resultColor = half4(rd.color.x, rd.color.y, rd.color.z, 1);
    }

    return resultColor;
}
