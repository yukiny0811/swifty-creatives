//
//  SharedIndices.h
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

#ifndef SharedIndices_h
#define SharedIndices_h

typedef enum {
    VertexAttribute_Position = 0,
    VertexAttribute_UV = 1,
    VertexAttribute_Normal = 2,
    VertexAttribute_Color = 3,
} VertexAttributeIndex;

typedef enum {
    VertexBuffer_Position = 0,
    VertexBuffer_ModelPos = 1,
    VertexBuffer_ModelRot = 2,
    VertexBuffer_ModelScale = 3,
    VertexBuffer_ProjectionMatrix = 4,
    VertexBuffer_ViewMatrix = 5,
    VertexBuffer_CameraPos = 6,
    VertexBuffer_Color = 10,
    VertexBuffer_UV = 11,
    VertexBuffer_Normal = 12,
    VertexBuffer_CustomMatrix = 15,
    VertexBuffer_UseVertexColor = 18,
    VertexBuffer_VertexColor = 19,
} VertexBufferIndex;

typedef enum {
    FragmentBuffer_Material = 1,
    FragmentBuffer_LightCount = 2,
    FragmentBuffer_Lights = 3,
    FragmentBuffer_HasTexture = 6,
    FragmentBuffer_IsActiveToLight = 7,
    FragmentBuffer_FogDensity = 16,
    FragmentBuffer_FogColor = 17,
} FragmentBufferIndex;

typedef enum {
    FragmentTexture_MainTexture = 0,
    FragmentTexture_SkyBox = 30
} FragmentTextureIndex;

#endif /* SharedIndices_h */
