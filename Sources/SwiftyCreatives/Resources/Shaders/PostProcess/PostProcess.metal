//
//  PostProcess.metal
//
//
//  Created by Yuki Kuwashima on 2022/12/16.
//

#include <metal_stdlib>
#include "../Functions.metal"
using namespace metal;

kernel void plainPostProcess(   texture2d<float, access::read_write> tex [[texture(0)]],
                                const device float* args [[buffer(0)]],
                                ushort2 gid [[thread_position_in_grid]]) {
    float4 color = tex.read(gid);
    tex.write(color, gid);
}

inline float dist(float2 p1, float2 p2) {
    return pow(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2), 0.5);
}

kernel void cornerRadiusPostProcess(   texture2d<float, access::read_write> tex [[texture(0)]],
                                const device float* args [[buffer(0)]],
                                ushort2 gid [[thread_position_in_grid]]) {
    float width = tex.get_width();
    float height = tex.get_height();
    float4 color = tex.read(gid);
    if (gid.x < args[0]) {
        if (gid.y < args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(args[0], args[0]));
            if (distance > args[0]) {
                color = float4(0);
            }
        } else if (gid.y > height - args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(args[0], height - args[0]));
            if (distance > args[0]) {
                color = float4(0);
            }
        }
    } else if (gid.x > width - args[0]) {
        if (gid.y < args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(width - args[0], args[0]));
            if (distance > args[0]) {
                color = float4(0);
            }
        } else if (gid.y > height - args[0]) {
            float distance = dist(float2(gid.x, gid.y), float2(width - args[0], height - args[0]));
            if (distance > args[0]) {
                color = float4(0);
            }
        }
    }
    tex.write(color, gid);
}
