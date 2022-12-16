//
//  Simple_Types.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#include <metal_stdlib>
using namespace metal;

struct FrameUniforms_ProjectionMatrix {
    float4x4 value;
};

struct FrameUniforms_ViewMatrix {
    float4x4 value;
};

struct FrameUniforms_Color {
    float4 value;
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

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};

struct Vertex {
    float3 position [[ attribute(0) ]];
};
