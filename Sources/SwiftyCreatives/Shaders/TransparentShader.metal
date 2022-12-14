//
//  TransparentShader.metal
//  
//
//  Created by Yuki Kuwashima on 2022/12/14.
//

#include <metal_stdlib>
using namespace metal;

// MARK: structs

struct FrameUniforms {
    float4x4 projectionMatrix;
    float4x4 viewMatrix;
};

struct ColorInOut {
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

// MARK: vertexTransform

vertex ColorInOut vertexTransform(Vertex vIn [[ stage_in ]],
                                  constant FrameUniforms &frameUniforms [[ buffer(5) ]]) {

    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, vIn.modelPos.x),
                                         float4(0.0, 1.0, 0.0, vIn.modelPos.y),
                                         float4(0.0, 0.0, 1.0, vIn.modelPos.z),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosX = cos(vIn.modelRot.x);
    const float sinX = sin(vIn.modelRot.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, -sinX, 0.0),
                                           float4(0.0, sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(vIn.modelRot.y);
    const float sinY = sin(vIn.modelRot.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(-sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(vIn.modelRot.z);
    const float sinZ = sin(vIn.modelRot.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, -sinZ, 0.0, 0.0),
                                           float4(sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));
                                                
    float4x4 modelScaleMatrix = float4x4(float4(vIn.modelScale.x, 0.0, 0.0, 0.0),
                                         float4(0.0, vIn.modelScale.y, 0.0, 0.0),
                                         float4(0.0, 0.0, vIn.modelScale.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));
    
    float4x4 modelMatrix = transpose(modelScaleMatrix * modelRotateXMatrix * modelRotateYMatrix * modelRotateZMatrix * modelTransMatrix);
    
    ColorInOut out;
    float4 position = float4(vIn.position, 1.0);
    out.position = frameUniforms.projectionMatrix * frameUniforms.viewMatrix * modelMatrix * position;
    out.color = vIn.color;
    return out;
}

// MARK: transparency

constant uint useDeviceMemory [[ function_constant(0) ]];

typedef rgba8unorm<half4> rgba8storage;
typedef r8unorm<half> r8storage;

template <int NUM_LAYERS>
struct OITData {
    static constexpr constant short s_numLayers = NUM_LAYERS;
    rgba8storage colors [[ raster_order_group(0) ]] [NUM_LAYERS];
    half depths [[ raster_order_group(0) ]] [NUM_LAYERS];
    r8storage transmittances [[ raster_order_group(0) ]] [NUM_LAYERS];
};

template <int NUM_LAYERS>
struct OITImageblock {
    OITData<NUM_LAYERS> oitData;
};

template <int NUM_LAYERS>
struct FragOut {
    OITImageblock<NUM_LAYERS> aoitImageBlock [[ imageblock_data ]];
};

template <typename OITDataT>
inline void InsertFragment(OITDataT oitData, half4 color, half depth, half transmittance) {
    const short numLayers = oitData->s_numLayers;
    for (short i = 0; i < numLayers - 1; ++i) {
        half layerDepth = oitData->depths[i];
        half4 layerColor = oitData->colors[i];
        half layerTransmittance = oitData->transmittances[i];

        bool insert = (depth <= layerDepth);
        oitData->colors[i] = insert ? color : layerColor;
        oitData->depths[i] = insert ? depth : layerDepth;
        oitData->transmittances[i] = insert ? transmittance : layerTransmittance;

        color = insert ? layerColor : color;
        depth = insert ? layerDepth : depth;
        transmittance = insert ? layerTransmittance : transmittance;
    }
    const short lastLayer = numLayers - 1;
    half lastDepth = oitData->depths[lastLayer];
    half4 lastColor = oitData->colors[lastLayer];
    half lastTransmittance = oitData->transmittances[lastLayer];

    bool newDepthFirst = (depth <= lastDepth);

    half firstDepth = newDepthFirst ? depth : lastDepth;
    half4 firstColor = newDepthFirst ? color : lastColor;
    half4 secondColor = newDepthFirst ? lastColor : color;
    half firstTransmittance = newDepthFirst ? transmittance : lastTransmittance;

    oitData->colors[lastLayer] = firstColor + secondColor * firstTransmittance;
    oitData->depths[lastLayer] = firstDepth;
    oitData->transmittances[lastLayer] = transmittance * lastTransmittance;
}

template <typename OITDataT>
void OITFragmentFunction(ColorInOut in,
                         constant FrameUniforms &uniforms,
                         OITDataT oitData) {
    const float depth = in.position.z / in.position.w;
    half4 fragmentColor = half4(in.color);
    fragmentColor.rgb *= (1 - fragmentColor.a);
    InsertFragment(oitData, fragmentColor, depth, 1 - fragmentColor.a);
}

template <int NUM_LAYERS>
void OITClear(imageblock<OITImageblock<NUM_LAYERS>, imageblock_layout_explicit> oitData, ushort2 tid) {
    threadgroup_imageblock OITData<NUM_LAYERS> &pixelData = oitData.data(tid)->oitData;
    const short numLayers = pixelData.s_numLayers;
    for (ushort i = 0; i < numLayers; ++i) {
        pixelData.colors[i] = half4(0.0);
        pixelData.depths[i] = 65504.0;
        pixelData.transmittances[i] = 1.0;
    }
}

template <int NUM_LAYERS>
half4 OITResolve(OITData<NUM_LAYERS> pixelData) {
    const short numLayers = pixelData.s_numLayers;
    half4 finalColor = 0;
    half transmittance = 1;
    for (ushort i = 0; i < numLayers; ++i) {
        finalColor += (half4)pixelData.colors[i] * transmittance;
        transmittance *= (half)pixelData.transmittances[i];
    }
    finalColor.w = 1;
    return finalColor;
}

fragment FragOut<4>
OITFragmentFunction_4Layer(ColorInOut in [[ stage_in ]],
                           constant FrameUniforms &uniforms [[ buffer (5) ]],
                           OITImageblock<4> oitImageblock [[ imageblock_data ]]) {
    OITFragmentFunction(in, uniforms, &oitImageblock.oitData);
    FragOut<4> Out;
    Out.aoitImageBlock = oitImageblock;
    return Out;
}

kernel void OITClear_4Layer(imageblock<OITImageblock<4>, imageblock_layout_explicit> oitData,
                            ushort2 tid [[ thread_position_in_threadgroup ]]) {
    OITClear(oitData, tid);
}

fragment half4 OITResolve_4Layer(OITImageblock<4> oitImageblock [[ imageblock_data ]]) {
    return OITResolve(oitImageblock.oitData);
}

