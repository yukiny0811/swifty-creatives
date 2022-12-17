//
//  TransparentShader.metal
//
//  Original source code from Apple Inc. https://developer.apple.com/videos/play/tech-talks/605/
//  Modified by Yuki Kuwashima on 2022/12/14.
//
//  Copyright © 2017 Apple Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include <metal_stdlib>
#include "Types.metal"
using namespace metal;

// MARK: vertexTransform

vertex RasterizerData vertexTransform(Vertex vIn [[ stage_in ]],
                                      const device FrameUniforms_Color& uniformColor [[ buffer(1) ]],
                                      const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(2) ]],
                                      const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(3) ]],
                                      const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(4) ]],
                                      const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(5) ]],
                                      const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(6) ]]) {

    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, uniformModelPos.value.x),
                                         float4(0.0, 1.0, 0.0, uniformModelPos.value.y),
                                         float4(0.0, 0.0, 1.0, uniformModelPos.value.z),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosX = cos(uniformModelRot.value.x);
    const float sinX = sin(uniformModelRot.value.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, -sinX, 0.0),
                                           float4(0.0, sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(uniformModelRot.value.y);
    const float sinY = sin(uniformModelRot.value.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(-sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(uniformModelRot.value.z);
    const float sinZ = sin(uniformModelRot.value.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, -sinZ, 0.0, 0.0),
                                           float4(sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));
                                                
    float4x4 modelScaleMatrix = float4x4(float4(uniformModelScale.value.x, 0.0, 0.0, 0.0),
                                         float4(0.0, uniformModelScale.value.y, 0.0, 0.0),
                                         float4(0.0, 0.0, uniformModelScale.value.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));
    
    float4x4 modelMatrix = transpose(modelScaleMatrix * modelRotateXMatrix * modelRotateYMatrix * modelRotateZMatrix * modelTransMatrix);
    
    RasterizerData out;
    float4 position = float4(vIn.position, 1.0);
    out.position = uniformProjectionMatrix.value * uniformViewMatrix.value * modelMatrix * position;
    out.color = uniformColor.value;
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
void OITFragmentFunction(RasterizerData in,
                         OITDataT oitData) {
    const float depth = in.position.z / in.position.w;
    half4 fragmentColor = half4(in.color);
    
//    fragmentColor.rgb *= (1 - fragmentColor.a);
    fragmentColor.rgb *= fragmentColor.a;
    
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
//    finalColor.w = 1;
    return finalColor;
}

fragment FragOut<4>
OITFragmentFunction_4Layer(RasterizerData in [[ stage_in ]],
                           OITImageblock<4> oitImageblock [[ imageblock_data ]]) {
    OITFragmentFunction(in, &oitImageblock.oitData);
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

