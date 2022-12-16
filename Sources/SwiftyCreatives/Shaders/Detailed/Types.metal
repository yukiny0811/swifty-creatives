//
//  Types.metal
//  
//
//  Created by Yuki Kuwashima on 2022/12/15.
//

#include <metal_stdlib>
using namespace metal;

struct FrameUniforms {
    float4x4 projectionMatrix;
    float4x4 viewMatrix;
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};

struct Vertex {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 modelPos [[ attribute(2) ]];
    float3 modelRot [[ attribute(3) ]];
    float3 modelScale [[ attribute(4) ]];
};
