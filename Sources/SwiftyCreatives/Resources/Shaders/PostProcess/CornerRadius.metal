
#include <metal_stdlib>
#include "../Functions.metal"
using namespace metal;

inline float4 process(float4 readColor, const device float* args, ushort2 gid, float width, float height) {
    if (gid.x < args[0]) {
        if (gid.y < args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(args[0], args[0]));
            if (distance > args[0]) {
                readColor = float4(0);
            }
        } else if (gid.y > height - args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(args[0], height - args[0]));
            if (distance > args[0]) {
                readColor = float4(0);
            }
        }
    } else if (gid.x > width - args[0]) {
        if (gid.y < args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(width - args[0], args[0]));
            if (distance > args[0]) {
                readColor = float4(0);
            }
        } else if (gid.y > height - args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(width - args[0], height - args[0]));
            if (distance > args[0]) {
                readColor = float4(0);
            }
        }
    }
    return readColor;
}

kernel void cornerRadiusPostProcess(   texture2d<float, access::read_write> tex [[texture(0)]],
                                const device float* args [[buffer(0)]],
                                ushort2 gid [[thread_position_in_grid]]) {
    float width = tex.get_width();
    float height = tex.get_height();
    float4 color = process(tex.read(gid), args, gid, width, height);
    tex.write(color, gid);
}

kernel void cornerRadiusPostProcess_Slow(   texture2d<float, access::read> texRead [[texture(0)]],
                                         texture2d<float, access::write> texWrite [[texture(1)]],
                                const device float* args [[buffer(0)]],
                                ushort2 gid [[thread_position_in_grid]]) {
    float width = texRead.get_width();
    float height = texRead.get_height();
    float4 color = process(texRead.read(gid), args, gid, width, height);
    texWrite.write(color, gid);
}
