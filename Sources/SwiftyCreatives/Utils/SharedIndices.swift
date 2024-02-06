//
//  SharedIndices.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//
//
// from Resources/Shaders/SharedIndices.h

enum VertexAttributeIndex: Int {
    case Position = 0
    case UV = 1
    case Normal = 2
    case Color = 3
}

enum VertexBufferIndex: Int {
    case Position = 0
    case ModelPos = 1
    case ModelRot = 2
    case ModelScale = 3
    case ProjectionMatrix = 4
    case ViewMatrix = 5
    case CameraPos = 6
    case Color = 10
    case UV = 11
    case Normal = 12
    case CustomMatrix = 15
    case UseVertexColor = 18
    case VertexColor = 19
}

enum FragmentBufferIndex: Int {
    case Material = 1
    case LightCount = 2
    case Lights = 3
    case HasTexture = 6
    case IsActiveToLight = 7
    case FogDensity = 16
    case FogColor = 17
}

enum FragmentTextureIndex: Int {
    case MainTexture = 0
    case SkyBox = 30
}
