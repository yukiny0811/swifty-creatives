

#include <metal_stdlib>
#include "../Functions.metal"
using namespace metal;

kernel void textColorPostProcess(texture2d<float, access::read> original [[texture(0)]],
                                  texture2d<float, access::write> target [[texture(1)]],
                                  const device float4* textColor [[buffer(0)]],
                                  ushort2 gid [[thread_position_in_grid]]) {
    float4 color = original.read(gid);
    if (color.a != 0) {
        color = textColor[0];
    }
    target.write(color, gid);
}
