
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
using namespace raytracing;

#include "../../../SwiftyCreativesCore/include/SwiftyCreativesCore.h"

constant float PI = 3.14159265;

inline float rand(int x, int y, int z) {
    int seed = x + y * 57 + z * 241;
    seed = (seed<< 13) ^ seed;
    return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
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

kernel void rayTrace(
    texture2d<half, access::write> drawableTex [[ texture(0) ]],
    const device RayTracingUniform& uniform [[ buffer(1) ]],
    primitive_acceleration_structure accelerationStructure [[ buffer(2) ]],
    const device float3& randomFactor [[ buffer(3) ]],
    const device int& bounceCount [[ buffer(4) ]],
    const device int& sampleCount [[ buffer(5) ]],
    const device PointLight* pointLights [[ buffer(6) ]],
    const device int& pointLightCount [[ buffer(7) ]],
    ushort2 gid [[ thread_position_in_grid ]]
) {
    float width = drawableTex.get_width();
    float height = drawableTex.get_height();
    float normalizedX = (float(gid.x) - width / 2) / width;
    float normalizedY = (float(gid.y) - height / 2) / width;
    float4 globalCameraPos = uniform.cameraTransform * float4(0, 0, 0, 1);
    float4 globalCameraDirection = uniform.cameraTransform * float4(normalizedX, -normalizedY, 1, 1);
    
    intersector<triangle_data> intersector;
    
    ray r;
    r.origin = globalCameraPos.xyz;
    r.direction = normalize(globalCameraDirection.xyz - r.origin);
    r.max_distance = INFINITY;
    
    float4 finalColor = float4(0, 0, 0, 0);
    
    for (int s = 0; s < sampleCount; s++) {
        
        float4 thisSampleColor = float4(0, 0, 0, 0);
        int bouncedCount = 0;
        
        for (int b = 0; b < bounceCount; b++) {

            // main ray
            intersection_result<triangle_data> intersection;
            intersection = intersector.intersect(r, accelerationStructure);
            
            if (intersection.type == intersection_type::none) {
                break;
            }
            bouncedCount += 1;
            
            float dist = intersection.distance;
            float2 coords = intersection.triangle_barycentric_coord;
            RayTraceTriangle triangle = *(const device RayTraceTriangle*)intersection.primitive_data;
            
            // shadow ray
            float4 shadowColor = float4(0, 0, 0, 0);
            for (int pl = 0; pl < pointLightCount; pl++) {
                ray shadowRay;
                shadowRay.origin = r.origin + r.direction * dist;
                shadowRay.direction = normalize(pointLights[pl].pos - shadowRay.origin);
                shadowRay.max_distance = INFINITY;
                intersection_result<triangle_data> shadowIntersection;
                shadowIntersection = intersector.intersect(shadowRay, accelerationStructure);
                
                if (shadowIntersection.type == intersection_type::none) {
                    float3 thisShadowColor = pointLights[pl].color * pointLights[pl].intensity;
                    shadowColor += float4(thisShadowColor, 1);
                }
            }
            if (pointLightCount > 0) {
                shadowColor /= pointLightCount;
            }
            
            // new ray
            float3 thisNormal = dot(r.direction, triangle.normal) < 0 ? triangle.normal : -triangle.normal;
            r.origin = r.origin + r.direction * dist;
            r.direction = lambertDiffusion(thisNormal, float2(gid.x, gid.y), randomFactor);
            
            //composition
            thisSampleColor += triangle.colors[0] * (1.0 / float(bouncedCount)) * shadowColor;
        }
        if (bouncedCount > 0) {
            finalColor += thisSampleColor / float(bouncedCount);
        }
    }
    drawableTex.write(half4(finalColor / float(sampleCount)), gid);
}

//kernel void rayTrace(
//    texture2d<half, access::write> drawableTex [[ texture(0) ]],
//    const device RayTracingUniform& uniform [[ buffer(1) ]],
//    primitive_acceleration_structure accelerationStructure [[ buffer(2) ]],
//    const device float3& randomFactor [[ buffer(3) ]],
//    ushort2 gid [[ thread_position_in_grid ]]
//) {
//    float width = rayOriginTex.get_width();
//    float height = rayOriginTex.get_height();
//    float normalizedX = (float(gid.x) - width / 2) / width;
//    float normalizedY = (float(gid.y) - height / 2) / width;
//    
//    Ray ray;
//    float4 globalCameraPos = uniform.cameraTransform * float4(0, 0, 0, 1);
//    ray.origin = globalCameraPos.xyz;
//    float4 globalCameraDirection = uniform.cameraTransform * float4(normalizedX, -normalizedY, 1, 1);
//    ray.direction = globalCameraDirection.xyz - ray.origin;
//    ray.direction = normalize(ray.direction);
//    
//    rayOriginTex.write(float4(ray.origin, 0), gid);
//    rayDirectionTex.write(float4(ray.direction, 0), gid);
//    rayColorTex.write(float4(1, 1, 1, 1), gid);
//    rayParameterTex.write(float4(0, 0, 0, 0), gid);
//}
//
//kernel void rayTrace_calculateRay(
//    texture2d<float, access::read_write> rayOriginTex [[ texture(1) ]],
//    texture2d<float, access::read_write> rayDirectionTex [[ texture(2) ]],
//    texture2d<float, access::read_write> rayColorTex [[ texture(3) ]],
//    texture2d<float, access::read_write> rayParameterTex [[ texture(4) ]],
//    const device RayTracingVertex* vertices [[ buffer(0) ]],
//    const device RayTracingUniform& uniform [[ buffer(1) ]],
//    const device int& vertexCount [[ buffer(2) ]],
//    const device float3& randomFactor [[ buffer(3) ]],
//    ushort2 gid [[ thread_position_in_grid ]]
//) {
//    Ray ray;
//    ray.origin = rayOriginTex.read(gid).xyz;
//    ray.direction = rayDirectionTex.read(gid).xyz;
//    ray.color = rayColorTex.read(gid);
//    ray.bounceCount = int(rayParameterTex.read(gid).r);
//    ray.finished = int(rayParameterTex.read(gid).g);
//    
//    for (int i = 0; i < 2; i++) {
//        
//        if (ray.finished == 1) { break; }
//        
//        bool foundIntersection = false;
//        float shortestT = 10000.0;
//        RayTracingVertex shortestTriangle;
//        
//        for (int c = 0; c < vertexCount; c++) {
//            float t = checkIntersection(ray, vertices[c]);
//            if (t > 0.00001) {
//                foundIntersection = true;
//                if (t < shortestT) {
//                    shortestT = t;
//                    shortestTriangle = vertices[c];
//                }
//            }
//        }
//        
//        if (foundIntersection == false) {
//            ray.finished = 1;
//            ray.color = ray.color * float4(0.1, 0.1, 0.1, 1);
//            break;
//        }
//        
//        ray.color = shortestTriangle.color * ray.color;
//        ray.origin = ray.origin + ray.direction * shortestT;
//        float3 thisNormal = dot(ray.direction, shortestTriangle.normal) < 0 ? shortestTriangle.normal : -shortestTriangle.normal;
//        ray.direction = lambertDiffusion(thisNormal, float2(gid.x, gid.y), randomFactor);
//        ray.bounceCount += 1;
//    }
//    
//    rayOriginTex.write(float4(ray.origin, 0), gid);
//    rayDirectionTex.write(float4(ray.direction, 0), gid);
//    rayColorTex.write(ray.color, gid);
//    rayParameterTex.write(float4(float(ray.bounceCount), float(ray.finished), 0, 0), gid);
//}
//
//kernel void rayTrace_addSample(
//    texture2d<float, access::read_write> rayColorTex [[ texture(3) ]],
//    texture2d<float, access::read_write> sampleSumTex [[ texture(5) ]],
//    ushort2 gid [[ thread_position_in_grid ]]
//) {
//    float4 color = rayColorTex.read(gid);
//    sampleSumTex.write(sampleSumTex.read(gid) + color, gid);
//}
//
//kernel void rayTrace_drawRay(
//    texture2d<float, access::read_write> drawableTex [[ texture(0) ]],
//    texture2d<float, access::read_write> sampleSumTex [[ texture(5) ]],
//    const device int& sampleCount [[ buffer(4) ]],
//    ushort2 gid [[ thread_position_in_grid ]]
//) {
//    float4 color = sampleSumTex.read(gid);
//    drawableTex.write(color / sampleCount, gid);
//}
