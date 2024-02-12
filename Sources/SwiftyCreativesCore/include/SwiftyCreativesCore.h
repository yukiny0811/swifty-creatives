//
//  Header.h
//  
//
//  Created by Yuki Kuwashima on 2024/02/12.
//

#ifndef Bridging_Header_h_h
#define Bridging_Header_h_h

#include <simd/simd.h>

typedef struct {
    int objectType;
    simd_float4x4 inverseTransform;
    simd_float4 parameter1;
    simd_float4 parameter2;
    simd_float4 parameter3;
} RayMarchObject;

typedef struct {
    simd_float4x4 cameraTransform;
} RayMarchUniform;

#endif
