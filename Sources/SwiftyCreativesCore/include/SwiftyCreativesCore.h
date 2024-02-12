//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/08.
//

#ifndef Bridging_Header_h_h
#define Bridging_Header_h_h

#include <simd/simd.h>

typedef struct {
    simd_float3 v1;
    simd_float3 v2;
    simd_float3 v3;
    simd_float2 uv1;
    simd_float2 uv2;
    simd_float2 uv3;
    simd_float3 normal;
    simd_float4 color;
} RayTracingVertex;

typedef struct {
    simd_float4x4 cameraTransform;
} RayTracingUniform;

typedef struct {
    simd_float3 origin;
    simd_float3 direction;
    simd_float4 color;
    int bounceCount;
    int finished; // 1 if true
} Ray;

struct RayTraceTriangle {
    vector_float3 positions[3];
    simd_float3 normal;
    vector_float4 colors[3];
    vector_float2 uvs[3];
};

struct PointLight {
    simd_float3 pos;
    simd_float3 color;
    float intensity;
}

#endif
