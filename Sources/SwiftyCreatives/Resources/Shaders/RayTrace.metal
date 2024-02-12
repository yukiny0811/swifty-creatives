
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
using namespace raytracing;

#include "../../../SwiftyCreativesCore/include/SwiftyCreativesCore.h"

constant float PI = 3.14159265;
constant float INV_PI = 1.0 / PI;

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

inline float3 lambertDiffusionWithRandomReflection(float3 normal, float2 fgid, float3 randomFactor, float3 reflected, float metallic) {
    if (rand(fgid.y * randomFactor.x, randomFactor.z, fgid.x * randomFactor.y) < metallic) {
        return normalize(reflected);
    }
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

inline float3 diffuseOrenNayarBrdf(float3 reflectance, float3 normal, float3 viewDir, float3 lightDir, float roughness) { //viewDisが次の光線のdir reflectanceがalbedo
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

float3 fresnelSchlick(float3 f0, float cosine) {
    return f0 + (1.0 - f0) * pow(1.0 - cosine, 5.0);
}

float normalDistributionGgx(float3 normal, float3 halfDir, float roughness) {
    float roughness2 = roughness * roughness;
    float dotNH = saturate(dot(normal, halfDir));
    float a = (1.0 - (1.0 - roughness2) * dotNH * dotNH);
    return roughness2 * INV_PI / (a * a);
}

float maskingShadowingSmithJoint(float3 normal, float3 viewDir, float3 lightDir, float roughness) {
    float roughness2 = roughness * roughness;
    float dotNV = saturate(dot(normal, viewDir));
    float dotNL = saturate(dot(normal, lightDir));
    float lv = 0.5 * (-1.0 + sqrt(1.0 + roughness2 * (1.0 / (dotNV * dotNV) - 1.0)));
    float ll = 0.5 * (-1.0 + sqrt(1.0 + roughness2 * (1.0 / (dotNL * dotNL) - 1.0)));
    return 1.0 / (1.0 + lv + ll);
}

float3 specularCookTorranceBrdf(float3 reflectance, float3 normal, float3 viewDir, float3 lightDir, float roughness) {
    float3 halfDir = normalize(viewDir + lightDir);
    float dotNV = saturate(dot(normal, viewDir));
    float dotNL = saturate(dot(normal, lightDir));
    float dotVH = saturate(dot(viewDir, halfDir));
    float d = normalDistributionGgx(normal, halfDir, roughness);
    float g = maskingShadowingSmithJoint(normal, viewDir, lightDir, roughness);
    float3 f = fresnelSchlick(reflectance, dotVH);
    return d  * g * f / (4.0 * dotNV * dotNL);
}

// returns color
float3 backTraceRay(
                           const float3 currentPosition,
                           const float currentRoughness,
                           const float currentMetallic,
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
        
        if (dot(lightRay.direction, normal) < 0) {
            continue;
        }
        
        lightRay.origin = lightRay.origin + lightRay.direction * 0.001;
        lightRay.max_distance = INFINITY;
        
        intersection_result<triangle_data> lightIntersection;
        lightIntersection = intersector.intersect(lightRay, accelerationStructure);
        
        if (lightIntersection.type == intersection_type::none) {
            float3 thisLightColor = lights[pl].color * lights[pl].intensity;
            
            float3 diffuseBRDF = diffuseOrenNayarBrdf(thisColor, normal, toDirection, lightRay.direction, currentRoughness);
            float3 specularBRDF = specularCookTorranceBrdf(thisColor, normal, toDirection, lightRay.direction, currentRoughness);
            float3 f = (1.0 - currentMetallic) * diffuseBRDF + currentMetallic * specularBRDF;
            
            toColor += thisLightColor * f;
        }
    }
    if (traceDepth >= bounceCount) {
        return toColor;
    }
    
    float3 thisRandomFactor = float3(randomFactor.x * float(traceDepth + 1) * 10, randomFactor.y * float(s + 1) * 10, randomFactor.z * float(s + 1) * float(traceDepth + 1) * 10);
    float3 fromDirection = lambertDiffusionWithRandomReflection(normal, float2(gid.x, gid.y), thisRandomFactor, reflect(-toDirection, normal), currentMetallic);
    
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
                                    triangle.roughness,
                                    triangle.metallic,
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
                                         triangle.roughness,
                                         triangle.metallic,
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
