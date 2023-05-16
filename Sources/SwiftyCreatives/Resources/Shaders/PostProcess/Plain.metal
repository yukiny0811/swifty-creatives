#include <metal_stdlib>
#include "../Functions.metal"
using namespace metal;

kernel void plainPostProcess(   texture2d<float, access::read_write> tex [[texture(0)]],
                                const device float* args [[buffer(0)]],
                                ushort2 gid [[thread_position_in_grid]]) {
    float4 color = tex.read(gid);
    tex.write(color, gid);
}

kernel void plainPostProcess_Slow(texture2d<float, access::read> texRead [[texture(0)]],
                                  texture2d<float, access::write> texWrite [[texture(1)]],
                                  const device float* args [[buffer(0)]],
                                  ushort2 gid [[thread_position_in_grid]]) {
    float4 color = texRead.read(gid);
    texWrite.write(color, gid);
}

