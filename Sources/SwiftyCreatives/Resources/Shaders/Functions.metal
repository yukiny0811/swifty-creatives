//
//  Functions.metal
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

#include <metal_stdlib>
#include "Types.metal"
using namespace metal;

inline float4x4 createModelMatrix(
    Vertex vIn,
    const device FrameUniforms_ModelPos& uniformModelPos,
    const device FrameUniforms_ModelRot& uniformModelRot ,
    const device FrameUniforms_ModelScale& uniformModelScale,
    const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix,
    const device FrameUniforms_ViewMatrix& uniformViewMatrix,
    const device FrameUniforms_CustomMatrix& uniformCustomMatrix
) {
    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                         float4(0.0, 1.0, 0.0, 0.0),
                                         float4(0.0, 0.0, 1.0, 0.0),
                                         float4(uniformModelPos.value.x, uniformModelPos.value.y, uniformModelPos.value.z, 1.0));

    const float cosX = cos(uniformModelRot.value.x);
    const float sinX = sin(uniformModelRot.value.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, sinX, 0.0),
                                           float4(0.0, -sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(uniformModelRot.value.y);
    const float sinY = sin(uniformModelRot.value.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, -sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(uniformModelRot.value.z);
    const float sinZ = sin(uniformModelRot.value.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, sinZ, 0.0, 0.0),
                                           float4(-sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));
                                                
    float4x4 modelScaleMatrix = float4x4(float4(uniformModelScale.value.x, 0.0, 0.0, 0.0),
                                         float4(0.0, uniformModelScale.value.y, 0.0, 0.0),
                                         float4(0.0, 0.0, uniformModelScale.value.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));
    
    float4x4 modelMatrix = uniformCustomMatrix.value * modelTransMatrix * modelRotateZMatrix * modelRotateYMatrix * modelRotateXMatrix * modelScaleMatrix;
    return modelMatrix;
}

inline float4 createFog(float distance, float4 color, float density, float4 fogColor) {
    float fog = 1.0 - clamp(exp(-density * distance), 0.0, 1.0);
    return mix(color, fogColor, fog);
}

inline float dist(float2 p1, float2 p2) {
    return pow(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2), 0.5);
}
