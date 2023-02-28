




#include <metal_stdlib>
#include "../Functions.metal"
using namespace metal;

kernel void bloomPostProcess(texture2d<float, access::read> texRead [[texture(0)]],
                                  texture2d<float, access::write> texWrite [[texture(1)]],
                                  const device float* args [[buffer(0)]],
                                  ushort2 gid [[thread_position_in_grid]]) {
    float4 color = texRead.read(gid);
    float4 resultColor = float4(0, 0, 0, color.a);
    float total = color.r + color.g + color.b;
    if (total > args[0] * 3) { resultColor.rgb = color.rgb; }
    texWrite.write(resultColor, gid);
}

kernel void bloomAddPostProcess(texture2d<float, access::read> texRead [[texture(0)]],
                                texture2d<float, access::read> bloomTex [[texture(1)]],
                                  texture2d<float, access::write> texWrite [[texture(2)]],
                                  const device float* args [[buffer(0)]],
                                  ushort2 gid [[thread_position_in_grid]]) {
    float4 color = texRead.read(gid);
    float4 bloomColor = bloomTex.read(gid);
    float4 resultColor = float4(color.r + bloomColor.r,
                                color.g + bloomColor.g,
                                color.b + bloomColor.b,
                                color.a);
    texWrite.write(resultColor, gid);
}
