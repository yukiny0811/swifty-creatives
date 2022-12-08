//
//  RenderShader.metal
//  Yeahhhhh
//
//  Created by クワシマ・ユウキ on 2021/02/04.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float4 modelMatrix1 [[attribute(2)]];
    float4 modelMatrix2 [[attribute(3)]];
    float4 modelMatrix3 [[attribute(4)]];
    float4 modelMatrix4 [[attribute(5)]];
};

struct RasterizerData{
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float4x4 mat;
};

vertex RasterizerData test_vertex (const VertexIn vIn [[ stage_in ]],
        const device Uniforms& uniforms [[ buffer(1) ]]) {
            
    RasterizerData rd;
    float4x4 modelMatrix = float4x4(vIn.modelMatrix1, vIn.modelMatrix2, vIn.modelMatrix3, vIn.modelMatrix4);
    rd.position = uniforms.mat * modelMatrix * float4(vIn.position, 1.0);
    rd.color = vIn.color;
    return rd;
}

fragment half4 test_fragment (RasterizerData rd [[stage_in]]){
    float4 color = rd.color;
    return half4(color.r, color.g, color.b, color.a);
}
