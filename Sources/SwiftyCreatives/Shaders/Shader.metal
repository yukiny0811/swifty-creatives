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
    float3 modelPos [[attribute(2)]];
    float3 modelRot [[attribute(3)]];
    float3 modelScale [[attribute(4)]];
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
    
    float4x4 modelTransMatrix = float4x4(
                                         float4(1.0, 0.0, 0.0, vIn.modelPos.x),
                                         float4(0.0, 1.0, 0.0, vIn.modelPos.y),
                                         float4(0.0, 0.0, 1.0, vIn.modelPos.z),
                                         float4(0.0, 0.0, 0.0, 1.0)
                                         );
    
    const float cosX = cos(vIn.modelRot.x);
    const float sinX = sin(vIn.modelRot.x);
    float4x4 modelRotateXMatrix = float4x4(
                                         float4(1.0, 0.0, 0.0, 0.0),
                                         float4(0.0, cosX, -sinX, 0.0),
                                         float4(0.0, sinX, cosX, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0)
                                         );

    const float cosY = cos(vIn.modelRot.y);
    const float sinY = sin(vIn.modelRot.y);
    float4x4 modelRotateYMatrix = float4x4(
                                         float4(cosY, 0.0, sinY, 0.0),
                                         float4(0.0, 1.0, 0.0, 0.0),
                                         float4(-sinY, 0.0, cosY, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0)
                                         );

    const float cosZ = cos(vIn.modelRot.z);
    const float sinZ = sin(vIn.modelRot.z);
    float4x4 modelRotateZMatrix = float4x4(
                                         float4(cosZ, -sinZ, 0.0, 0.0),
                                         float4(sinZ, cosZ, 0.0, 0.0),
                                         float4(0.0, 0.0, 1.0, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0)
                                         );
                                                
    float4x4 modelScaleMatrix = float4x4(
                                         float4(vIn.modelScale.x, 0.0, 0.0, 0.0),
                                         float4(0.0, vIn.modelScale.y, 0.0, 0.0),
                                         float4(0.0, 0.0, vIn.modelScale.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0)
                                         );
                                                
    float4x4 modelMatrix = transpose(modelScaleMatrix * modelRotateXMatrix * modelRotateYMatrix * modelRotateZMatrix * modelTransMatrix);
    rd.position = uniforms.mat * modelMatrix * float4(vIn.position, 1.0);
    rd.color = vIn.color;
    return rd;
}

fragment half4 test_fragment (RasterizerData rd [[stage_in]], half4 c [[color(0)]]){
    return half4(rd.color) + c;
}
