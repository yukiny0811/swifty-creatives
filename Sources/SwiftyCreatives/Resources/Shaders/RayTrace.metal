
#include <metal_stdlib>
using namespace metal;

#include "../../../SwiftyCreativesCore/include/SwiftyCreativesCore.h"

constant float PI = 3.14159265;

inline float rand(int x, int y, int z) {
    int seed = x + y * 57 + z * 241;
    seed = (seed<< 13) ^ seed;
    return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
}

inline float checkIntersection(Ray ray, RayTracingVertex triangle) {
    float bottom = -dot(ray.direction, triangle.normal);
    if (abs(bottom) < 0.001) {
        return -1;
    }
    float top = dot((ray.origin - triangle.v1), triangle.normal);
    float t = top / bottom;
    if (t <= 0) {
        return -1;
    }
    float3 intersectingPoint = ray.origin + ray.direction * t;
    float3 cross1 = cross((intersectingPoint - triangle.v1), (triangle.v2 - triangle.v1));
    float3 cross2 = cross((intersectingPoint - triangle.v3), (triangle.v1 - triangle.v3));
    float3 cross3 = cross((intersectingPoint - triangle.v2), (triangle.v3 - triangle.v2));
    
    float dot1 = dot(cross1, triangle.normal);
    float dot2 = dot(cross2, triangle.normal);
    float dot3 = dot(cross3, triangle.normal);
    if (sign(dot1) == sign(dot2) && sign(dot2) == sign(dot3)) {
        return t;
    }
    return -1;
}

inline float3 lambertDiffusion(float3 normal, float2 fgid, float3 randomFactor) {
    float theta = rand(fgid.x * randomFactor.x, fgid.y * randomFactor.y, randomFactor.z) * PI * 2 - PI;
    float p = rand(fgid.x * randomFactor.y * 4, fgid.y * randomFactor.x * 3, randomFactor.z * 2);
    float phi = asin((2.0 * p) - 1.0);

    float newX = cos(phi) * cos(theta);
    float newY = cos(phi) * sin(theta);
    float newZ = sin(phi);
    
    return normalize(float3(newX, newY, newZ) + normalize(normal));
}

inline float3 lambertDiffusionWithFuzz(float3 normal, float2 fgid, float3 randomFactor, float fuzz) {
    float theta = rand(fgid.x * randomFactor.x, fgid.y * randomFactor.y, randomFactor.z) * PI * 2 - PI;
    float p = rand(fgid.x * randomFactor.y * 4, fgid.y * randomFactor.x * 3, randomFactor.z * 2);
    float phi = asin((2.0 * p) - 1.0);

    float newX = cos(phi) * cos(theta);
    float newY = cos(phi) * sin(theta);
    float newZ = sin(phi);
    
    return normalize(float3(newX, newY, newZ) * fuzz + normalize(normal));
}

kernel void rayTrace_initRay(
    texture2d<float, access::write> rayOriginTex [[ texture(1) ]],
    texture2d<float, access::write> rayDirectionTex [[ texture(2) ]],
    texture2d<float, access::write> rayColorTex [[ texture(3) ]],
    texture2d<float, access::write> rayParameterTex [[ texture(4) ]],
    const device RayTracingUniform& uniform [[ buffer(1) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    float width = rayOriginTex.get_width();
    float height = rayOriginTex.get_height();
    float normalizedX = (float(gid.x) - width / 2) / width;
    float normalizedY = (float(gid.y) - height / 2) / width;
    
    Ray ray;
    float4 globalCameraPos = uniform.cameraTransform * float4(0, 0, 0, 1);
    ray.origin = globalCameraPos.xyz;
    float4 globalCameraDirection = uniform.cameraTransform * float4(normalizedX, -normalizedY, 1, 1);
    ray.direction = globalCameraDirection.xyz - ray.origin;
    ray.direction = normalize(ray.direction);
    
    rayOriginTex.write(float4(ray.origin, 0), gid);
    rayDirectionTex.write(float4(ray.direction, 0), gid);
    rayColorTex.write(float4(0, 0, 0, 0), gid);
    rayParameterTex.write(float4(0, 0, 0, 0), gid);
}

kernel void rayTrace_calculateRay(
    texture2d<float, access::read_write> rayOriginTex [[ texture(1) ]],
    texture2d<float, access::read_write> rayDirectionTex [[ texture(2) ]],
    texture2d<float, access::read_write> rayColorTex [[ texture(3) ]],
    texture2d<float, access::read_write> rayParameterTex [[ texture(4) ]],
    const device RayTracingVertex* vertices [[ buffer(0) ]],
    const device RayTracingUniform& uniform [[ buffer(1) ]],
    const device int& vertexCount [[ buffer(2) ]],
    const device float3& randomFactor [[ buffer(3) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    Ray ray;
    ray.origin = rayOriginTex.read(gid).xyz;
    ray.direction = rayDirectionTex.read(gid).xyz;
    ray.color = rayColorTex.read(gid);
    ray.bounceCount = int(rayParameterTex.read(gid).r);
    ray.finished = int(rayParameterTex.read(gid).g);
    
    for (int i = 0; i < 10; i++) {
        
        if (ray.finished == 1) { break; }
        
        bool foundIntersection = false;
        float shortestT = 10000.0;
        RayTracingVertex shortestTriangle;
        
        for (int c = 0; c < vertexCount; c++) {
            float t = checkIntersection(ray, vertices[c]);
            if (t > 0.00001) {
                foundIntersection = true;
                if (t < shortestT) {
                    shortestT = t;
                    shortestTriangle = vertices[c];
                }
            }
        }
        
        if (foundIntersection == false) {
            ray.finished = 1;
            ray.color = (ray.color * float(ray.bounceCount) + float4(0.1, 0.1, 0.1, 1)) / float(ray.bounceCount + 1);
            break;
        }
        
        ray.color = (ray.color * float(ray.bounceCount) + shortestTriangle.color) / float(ray.bounceCount + 1);
        ray.origin = ray.origin + ray.direction * shortestT;
        float3 thisNormal = dot(ray.direction, shortestTriangle.normal) < 0 ? shortestTriangle.normal : -shortestTriangle.normal;
        ray.direction = lambertDiffusion(thisNormal, float2(gid.x, gid.y), randomFactor);
        ray.bounceCount += 1;
    }
    
    rayOriginTex.write(float4(ray.origin, 0), gid);
    rayDirectionTex.write(float4(ray.direction, 0), gid);
    rayColorTex.write(ray.color, gid);
    rayParameterTex.write(float4(float(ray.bounceCount), float(ray.finished), 0, 0), gid);
}

kernel void rayTrace_addSample(
    texture2d<float, access::read_write> rayColorTex [[ texture(3) ]],
    texture2d<float, access::read_write> sampleSumTex [[ texture(5) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    float4 color = rayColorTex.read(gid);
    sampleSumTex.write(sampleSumTex.read(gid) + color, gid);
}

kernel void rayTrace_drawRay(
    texture2d<float, access::read_write> drawableTex [[ texture(0) ]],
    texture2d<float, access::read_write> sampleSumTex [[ texture(5) ]],
    const device int& sampleCount [[ buffer(4) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    float4 color = sampleSumTex.read(gid);
    drawableTex.write(color / sampleCount, gid);
}
