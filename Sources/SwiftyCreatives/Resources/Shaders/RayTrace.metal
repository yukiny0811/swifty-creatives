
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
using namespace raytracing;

#include "../../../SwiftyCreativesCore/include/SwiftyCreativesCore.h"

constant float PI = 3.14159265;
constant float INV_PI = 1.0 / PI;

float rand(int x, int y, int z) {
    int seed = x + y * 57 + z * 241;
    seed = (seed<< 13) ^ seed;
    return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
}

float3 lambertDiffusion(float3 normal, float2 fgid, float3 randomFactor) {
    float theta = rand(fgid.x * randomFactor.x, fgid.y * randomFactor.y, randomFactor.z) * PI * 2 - PI;
    float p = rand(fgid.x * randomFactor.y * 4, fgid.y * randomFactor.x * 3, randomFactor.z * 2);
    float phi = asin((2.0 * p) - 1.0);

    float newX = cos(phi) * cos(theta);
    float newY = cos(phi) * sin(theta);
    float newZ = sin(phi);
    
    return normalize(float3(newX, newY, newZ) + normalize(normal));
}

float3 lambertDiffusionWithFuzz(float3 normal, float2 fgid, float3 randomFactor, float fuzz) {
    float theta = rand(fgid.x * randomFactor.x, fgid.y * randomFactor.y, randomFactor.z) * PI * 2 - PI;
    float p = rand(fgid.x * randomFactor.y * 4, fgid.y * randomFactor.x * 3, randomFactor.z * 2);
    float phi = asin((2.0 * p) - 1.0);

    float newX = cos(phi) * cos(theta);
    float newY = cos(phi) * sin(theta);
    float newZ = sin(phi);
    
    return normalize(float3(newX, newY, newZ) * fuzz + normalize(normal));
}

float3 diffuseOrenNayarBrdf(float3 reflectance, float3 normal, float3 viewDir, float3 lightDir, float roughness) { //viewDisが次の光線のdir reflectanceがalbedo
    float dotNV = saturate(dot(normal, viewDir));
    float dotNL = saturate(dot(normal, lightDir));
    float roughness2 = roughness * roughness;
    float a = 1.0 - 0.5 * roughness2 / (roughness2 + 0.33);
    float b = 0.45 * roughness2 / (roughness2 + 0.09);
    float cosPhi = dot(normalize(viewDir - dotNV * normal), normalize(lightDir - dotNL * normal)); // cos(phi_v, phi_l)
    float sinNV = sqrt(1.0 - dotNV * dotNV);
    float sinNL = sqrt(1.0 - dotNL * dotNL);
    float s = dotNV < dotNL ? sinNV : sinNL; // sin(max(theta_v, theta_l))
    float t = dotNV > dotNL ? sinNV / dotNV : sinNL / dotNL; // tan(min(theta_v, theta_l))
    return reflectance * INV_PI * (a + b * cosPhi * s * t);
}

// returns color
float3 backTraceRay(
                           const float3 currentPosition,
                           const float3 toDirection,
                           const float3 thisColor,
                           const device PointLight* lights,
                           const int lightCount,
                           const float3 normal,
                           const primitive_acceleration_structure accelerationStructure,
                           const int traceDepth, // first should be 0
                           const int bounceCount,
                           const float3 randomFactor,
                           const float2 gid,
                           const float s // sample count for random
) {
    intersector<triangle_data> intersector;
    float3 toColor = float3(0, 0, 0);
    for (int pl = 0; pl < lightCount; pl++) {
        ray lightRay;
        lightRay.origin = currentPosition;
        lightRay.direction = normalize(lights[pl].pos - currentPosition);
        lightRay.origin = lightRay.origin + lightRay.direction * 0.001;
        lightRay.max_distance = INFINITY;
        
        intersection_result<triangle_data> lightIntersection;
        lightIntersection = intersector.intersect(lightRay, accelerationStructure);
        
        if (lightIntersection.type == intersection_type::none) {
            float3 thisLightColor = lights[pl].color * lights[pl].intensity;
            toColor += thisLightColor * diffuseOrenNayarBrdf(thisColor, normal, toDirection, lightRay.direction, 0.5);
        }
    }
    if (traceDepth >= bounceCount) {
        return toColor;
    }
    
    float3 thisRandomFactor = float3(randomFactor.x * float(traceDepth + 1) * 10, randomFactor.y * float(s + 1) * 10, randomFactor.z * float(s + 1) * float(traceDepth + 1) * 10);
    float3 fromDirection = lambertDiffusion(normal, float2(gid.x, gid.y), thisRandomFactor);
    
    intersection_result<triangle_data> intersection;
    ray fromray;
    fromray.origin = currentPosition;
    fromray.direction = fromDirection;
    fromray.origin = fromray.origin + fromray.direction * 0.001;
    fromray.max_distance = INFINITY;
    intersection = intersector.intersect(fromray, accelerationStructure);
    
    if (intersection.type == intersection_type::none) {
        return toColor;
    }
    RayTraceTriangle triangle = *(const device RayTraceTriangle*)intersection.primitive_data;
    float3 thisNormal = dot(fromray.direction, triangle.normal) < 0 ? triangle.normal : -triangle.normal;
    float3 calculated = backTraceRay(
                                    fromray.origin + fromray.direction * intersection.distance,
                                    -fromDirection,
                                    triangle.colors[0].xyz,
                                    lights,
                                    lightCount,
                                    thisNormal,
                                    accelerationStructure,
                                    traceDepth + 1,
                                    bounceCount,
                                    randomFactor,
                                    gid,
                                    s
                                    );
    return toColor + thisColor * calculated;
}


kernel void rayTrace(
    texture2d<half, access::write> drawableTex [[ texture(0) ]],
    const device RayTracingUniform& uniform [[ buffer(1) ]],
    const primitive_acceleration_structure accelerationStructure [[ buffer(2) ]],
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
    
    float4 finalColor = float4(0, 0, 0, 0);
    
    for (int s = 0; s < sampleCount; s++) {
        
        intersection_result<triangle_data> intersection;
        ray fromray;
        fromray.origin = globalCameraPos.xyz;
        fromray.direction = normalize(globalCameraDirection.xyz - fromray.origin);
        fromray.max_distance = INFINITY;
        intersection = intersector.intersect(fromray, accelerationStructure);
        
        if (intersection.type == intersection_type::none) {
            continue;
        }
        RayTraceTriangle triangle = *(const device RayTraceTriangle*)intersection.primitive_data;
        float3 thisNormal = dot(fromray.direction, triangle.normal) < 0 ? triangle.normal : -triangle.normal;
        
        float3 backTraced = backTraceRay(
                                         fromray.origin + fromray.direction * intersection.distance,
                                         -fromray.direction,
                                         triangle.colors[0].xyz,
                                         pointLights,
                                         pointLightCount,
                                         thisNormal,
                                         accelerationStructure,
                                         1,
                                         bounceCount,
                                         randomFactor,
                                         float2(gid.x, gid.y),
                                         float(s+1)
                                         );
                                         
        finalColor += float4(backTraced, 1);
        
    }
    drawableTex.write(half4(finalColor / float(sampleCount)), gid);
}
