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
#include "Functions.metal"
using namespace metal;

// MARK: vertexTransform

vertex RasterizerData vertexTransform(Vertex vIn [[ stage_in ]],
                                      const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(VertexBuffer_ModelPos) ]],
                                      const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(VertexBuffer_ModelRot) ]],
                                      const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(VertexBuffer_ModelScale) ]],
                                      const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix [[ buffer(VertexBuffer_ProjectionMatrix) ]],
                                      const device FrameUniforms_UseVertexColor& useVertexColor [[ buffer(VertexBuffer_UseVertexColor) ]],
                                      const device FrameUniforms_ViewMatrix& uniformViewMatrix [[ buffer(VertexBuffer_ViewMatrix) ]],
                                      const device FrameUniforms_CameraPos& uniformCameraPos [[ buffer(VertexBuffer_CameraPos) ]],
                                      const device float4& color [[ buffer(VertexBuffer_Color) ]],
                                      const device FrameUniforms_CustomMatrix& uniformCustomMatrix [[ buffer(VertexBuffer_CustomMatrix) ]]
                                      ) {

    float4x4 modelMatrix = createModelMatrix(
                                             vIn,
                                             uniformModelPos,
                                             uniformModelRot,
                                             uniformModelScale,
                                             uniformProjectionMatrix,
                                             uniformViewMatrix,
                                             uniformCustomMatrix
                                             );
    
    RasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = (modelMatrix * float4(vIn.normal, 1.0)).xyz;
    rd.toCameraVector = uniformCameraPos.value - rd.worldPosition;
    rd.position = uniformProjectionMatrix.value * uniformViewMatrix.value * modelMatrix * float4(vIn.position, 1.0);
    rd.size = 1;
    if (useVertexColor.value) {
        rd.color = vIn.color;
    } else {
        rd.color = color;
    }
    rd.uv = vIn.uv;
    return rd;
}

vertex RasterizerData vertexTransform_vision(Vertex vIn [[ stage_in ]],
                                      const device FrameUniforms_ModelPos& uniformModelPos [[ buffer(VertexBuffer_ModelPos) ]],
                                      const device FrameUniforms_ModelRot& uniformModelRot [[ buffer(VertexBuffer_ModelRot) ]],
                                      const device FrameUniforms_ModelScale& uniformModelScale [[ buffer(VertexBuffer_ModelScale) ]],
                                      const device FrameUniforms_ProjectionMatrix* uniformProjectionMatrix [[ buffer(VertexBuffer_ProjectionMatrix) ]],
                                      const device FrameUniforms_UseVertexColor& useVertexColor [[ buffer(VertexBuffer_UseVertexColor) ]],
                                      const device FrameUniforms_ViewMatrix* uniformViewMatrix [[ buffer(VertexBuffer_ViewMatrix) ]],
                                      const device FrameUniforms_CameraPos& uniformCameraPos [[ buffer(VertexBuffer_CameraPos) ]],
                                      const device float4& color [[ buffer(VertexBuffer_Color) ]],
                                      const device FrameUniforms_CustomMatrix& uniformCustomMatrix [[ buffer(VertexBuffer_CustomMatrix) ]],
                                      ushort amp_id [[amplification_id]]
                                      ) {

    float4x4 modelMatrix = createModelMatrix(
                                             vIn,
                                             uniformModelPos,
                                             uniformModelRot,
                                             uniformModelScale,
                                             uniformProjectionMatrix[amp_id],
                                             uniformViewMatrix[amp_id],
                                             uniformCustomMatrix
                                             );
    
    RasterizerData rd;
    rd.worldPosition = (modelMatrix * float4(vIn.position, 1.0)).xyz;
    rd.surfaceNormal = (modelMatrix * float4(vIn.normal, 1.0)).xyz;
    rd.toCameraVector = uniformCameraPos.value - rd.worldPosition;
    rd.position = uniformProjectionMatrix[amp_id].value * uniformViewMatrix[amp_id].value * modelMatrix * float4(vIn.position, 1.0);
    if (useVertexColor.value) {
        rd.color = vIn.color;
    } else {
        rd.color = color;
    }
    rd.uv = vIn.uv;
    return rd;
}

// MARK: transparency

constant uint useDeviceMemory [[ function_constant(0) ]];

typedef rgba8unorm<float4> rgba8storage;
typedef r8unorm<float> r8storage;

template <int NUM_LAYERS>
struct OITData {
    static constexpr constant short s_numLayers = NUM_LAYERS;
    rgba8storage colors [[ raster_order_group(0) ]] [NUM_LAYERS];
    float depths [[ raster_order_group(0) ]] [NUM_LAYERS];
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
inline void InsertFragment(OITDataT oitData, float4 color, float depth, float transmittance) {
    const short numLayers = oitData->s_numLayers;
    for (short i = 0; i < numLayers - 1; ++i) {
        float layerDepth = oitData->depths[i];
        float4 layerColor = oitData->colors[i];
        float layerTransmittance = oitData->transmittances[i];

        bool insert = (depth <= layerDepth);
        oitData->colors[i] = insert ? color : layerColor;
        oitData->depths[i] = insert ? depth : layerDepth;
        oitData->transmittances[i] = insert ? transmittance : layerTransmittance;

        color = insert ? layerColor : color;
        depth = insert ? layerDepth : depth;
        transmittance = insert ? layerTransmittance : transmittance;
    }
    const short lastLayer = numLayers - 1;
    float lastDepth = oitData->depths[lastLayer];
    float4 lastColor = oitData->colors[lastLayer];
    float lastTransmittance = oitData->transmittances[lastLayer];

    bool newDepthFirst = (depth <= lastDepth);

    float firstDepth = newDepthFirst ? depth : lastDepth;
    float4 firstColor = newDepthFirst ? color : lastColor;
    float4 secondColor = newDepthFirst ? lastColor : color;
    float firstTransmittance = newDepthFirst ? transmittance : lastTransmittance;

    oitData->colors[lastLayer] = firstColor + secondColor * firstTransmittance;
    oitData->depths[lastLayer] = firstDepth;
    oitData->transmittances[lastLayer] = transmittance * lastTransmittance;
}

template <typename OITDataT>
void OITFragmentFunction(RasterizerData in,
                         OITDataT oitData,
                         FrameUniforms_HasTexture uniformHasTexture,
                         FrameUniforms_FogDensity uniformFogDensity,
                         FrameUniforms_FogColor uniformFogColor,
                         texture2d<float> tex) {
    const float depth = in.position.z / in.position.w;
    
    float4 fragmentColor = float4(in.color);
    fragmentColor.rgb *= (fragmentColor.a);
    
    if (uniformHasTexture.value) {
        constexpr sampler textureSampler (coord::pixel, address::clamp_to_edge, filter::linear);
        fragmentColor = tex.sample(textureSampler, float2(in.uv.x*tex.get_width(), in.uv.y*tex.get_height()));
    }

    if (fragmentColor.a == 0) {
        fragmentColor = float4(0, 0, 0, 0);
    }

    fragmentColor = float4(createFog(in.position.z / in.position.w,
                                    float4(fragmentColor),
                                    uniformFogDensity.value,
                                    uniformFogColor.value));
    
    InsertFragment(oitData, fragmentColor, depth, 1 - fragmentColor.a);
}

template <int NUM_LAYERS>
void OITClear(imageblock<OITImageblock<NUM_LAYERS>, imageblock_layout_explicit> oitData, ushort2 tid) {
    threadgroup_imageblock OITData<NUM_LAYERS> &pixelData = oitData.data(tid)->oitData;
    const short numLayers = pixelData.s_numLayers;
    for (ushort i = 0; i < numLayers; ++i) {
        pixelData.colors[i] = float4(0.0);
        pixelData.depths[i] = 3.4028235e+38;
        pixelData.transmittances[i] = 1.0;
    }
}

template <int NUM_LAYERS>
float4 OITResolve(OITData<NUM_LAYERS> pixelData) {
    const short numLayers = pixelData.s_numLayers;
    float4 finalColor = 0;
    float transmittance = 1;
    for (ushort i = 0; i < numLayers; ++i) {
        finalColor += (float4)pixelData.colors[i] * transmittance;
        transmittance *= (float)pixelData.transmittances[i];
    }
//    finalColor.w = 1;
    return finalColor;
}

fragment FragOut<4>
OITFragmentFunction_4Layer(RasterizerData in [[ stage_in ]],
                           OITImageblock<4> oitImageblock [[ imageblock_data ]],
                           const device FrameUniforms_HasTexture &uniformHasTexture [[ buffer(FragmentBuffer_HasTexture) ]],
                           const device FrameUniforms_FogDensity &fogDensity [[ buffer(FragmentBuffer_FogDensity) ]],
                           const device FrameUniforms_FogColor &fogColor [[ buffer(FragmentBuffer_FogColor) ]],
                           texture2d<float, access::sample> tex [[ texture(FragmentTexture_MainTexture) ]]) {
    OITFragmentFunction(in, &oitImageblock.oitData, uniformHasTexture, fogDensity, fogColor, tex);
    FragOut<4> Out;
    Out.aoitImageBlock = oitImageblock;
    return Out;
}

kernel void OITClear_4Layer(imageblock<OITImageblock<4>, imageblock_layout_explicit> oitData,
                            ushort2 tid [[ thread_position_in_threadgroup ]]) {
    OITClear(oitData, tid);
}

fragment float4 OITResolve_4Layer(OITImageblock<4> oitImageblock [[ imageblock_data ]]) {
    return OITResolve(oitImageblock.oitData);
}

