#include <metal_stdlib>
using namespace metal;

//Copyright 2024 Inigo Quilez
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include "../../../SwiftyCreativesCore/include/SwiftyCreativesCore.h"
#include "Functions.metal"
#include <simd/simd.h>

constant float PI = 3.14159265;

inline float rand(int x, int y, int z) {
    int seed = x + y * 57 + z * 241;
    seed = (seed<< 13) ^ seed;
    return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
}

inline float sdSphere(float3 p, float s) {
    return length(p)-s;
}

float sdBox( float3 p, float3 b )
{
  float3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

inline float sdfDistance(float3 origin, RayMarchObject object) {
    if (object.objectType == 1) {
        return sdSphere(origin, object.parameter1.x);
    } else if (object.objectType == 2) {
        return sdBox(origin, object.parameter1.xyz);
    }
    return 999999.0;
}

kernel void rayMarch(
    const device RayMarchObject* objects [[ buffer(0) ]],
    const device RayMarchUniform& uniform [[ buffer(1) ]],
    const device int& objectCount [[ buffer(2) ]],
    const device int& marchCount [[ buffer(3) ]],
    texture2d<half, access::write> drawableTex [[ texture(0) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    float width = drawableTex.get_width();
    float height = drawableTex.get_height();
    float normalizedX = (float(gid.x) - width / 2) / width;
    float normalizedY = (float(gid.y) - height / 2) / width;
    
    float4 globalCameraPos = uniform.cameraTransform * float4(0, 0, 0, 1);
    float3 origin = globalCameraPos.xyz;
    float4 globalCameraDirection = uniform.cameraTransform * float4(normalizedX, -normalizedY, 1, 1);
    float3 direction = normalize(globalCameraDirection.xyz - origin);
    
    float dist = 999999.0;
    for (int i = 0; i < marchCount; i++) {
        for (int o = 0; o < objectCount; o++) {
            dist = min(dist, sdfDistance((objects[o].inverseTransform * float4(origin.x, origin.y, origin.z, 1)).xyz, objects[o]));
        }
        if (dist < 0.01) {
            break;
        }
        origin = origin + direction * dist;
    }
    
    drawableTex.write(half4(dist > 0.01 ? 1 : 0, 0, 0, 1), gid);
}
