//
//  Types.metal
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#include <metal_stdlib>
#include "SharedIndices.h"
using namespace metal;

struct FrameUniforms_ProjectionMatrix {
    float4x4 value;
};

struct FrameUniforms_ViewMatrix {
    float4x4 value;
};

struct FrameUniforms_ModelPos {
    float3 value;
};

struct FrameUniforms_ModelRot {
    float3 value;
};

struct FrameUniforms_ModelScale {
    float3 value;
};

struct FrameUniforms_HasTexture {
    bool value;
};

struct FrameUniforms_CameraPos {
    float3 value;
};

struct FrameUniforms_IsActiveToLight {
    bool value;
};

struct FrameUniforms_CustomMatrix {
    float4x4 value;
};

struct FrameUniforms_FogDensity {
    float value;
};

struct FrameUniforms_FogColor {
    float4 value;
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float2 uv;
    float3 worldPosition;
    float3 surfaceNormal;
    float3 toCameraVector;
};

struct Vertex {
    float3 position [[ attribute(VertexAttribute_Position) ]];
    float2 uv [[ attribute(VertexAttribute_UV) ]];
    float3 normal [[ attribute(VertexAttribute_Normal) ]];
};

struct Light {
    float3 position;
    float3 color;
    float brightness;
    float ambientIntensity;
    float diffuseIntensity;
    float specularIntensity;
};

struct Material {
    float3 ambient;
    float3 diffuse;
    float3 specular;
    float shininess;
};
