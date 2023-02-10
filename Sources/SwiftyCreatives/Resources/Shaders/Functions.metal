//
//  Functions.metal
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

#include <metal_stdlib>
#include "Types.metal"
using namespace metal;

inline float3 calculatePhongIntensity(
                                      RasterizerData rd,
                                      const device Material &material,
                                      const device int &lightCount,
                                      const device Light *lights
                                      ) {
    float3 totalAmbient = float3(0, 0, 0);
    float3 totalDiffuse = float3(0, 0, 0);
    float3 totalSpecular = float3(0, 0, 0);
    
    float3 unitNormal = normalize(rd.surfaceNormal);
    float3 unitToCameraVector = normalize(rd.toCameraVector);
    
    for (int i = 0; i < lightCount; i++) {
        float3 unitToLightVector = normalize(lights[i].position - rd.worldPosition);
        float3 unitReflectionVector = normalize(reflect(-unitToLightVector, unitNormal));
        
        float3 ambientColor = clamp(material.ambient * lights[i].ambientIntensity * lights[i].brightness * lights[i].color, 0.0, 1.0);
        totalAmbient += ambientColor;
        
        float3 diffuseness = material.diffuse * lights[i].diffuseIntensity;
        float nDotL = max(dot(unitNormal, unitToLightVector), 0.0);
        float3 diffuseColor = clamp(diffuseness * nDotL * lights[i].brightness * lights[i].color, 0.0, 1.0);
        totalDiffuse += diffuseColor;
        
        float3 specularness = material.specular * lights[i].specularIntensity;
        float rDotV = max(dot(unitReflectionVector, unitToCameraVector), 0.0);
        float specularExponential = pow(rDotV, material.shininess);
        float3 specularColor = clamp(specularness * specularExponential * lights[i].brightness * lights[i].color, 0.0, 1.0);
        totalSpecular += specularColor;
    }
    float3 phongIntensity = totalAmbient + totalDiffuse + totalSpecular;
    
    return phongIntensity;
}

inline float4x4 createModelMatrix(
    Vertex vIn,
    const device FrameUniforms_ModelPos& uniformModelPos,
    const device FrameUniforms_ModelRot& uniformModelRot ,
    const device FrameUniforms_ModelScale& uniformModelScale,
    const device FrameUniforms_ProjectionMatrix& uniformProjectionMatrix,
    const device FrameUniforms_ViewMatrix& uniformViewMatrix,
    const device FrameUniforms_CustomMatrix& uniformCustomMatrix
) {
    float4x4 modelTransMatrix = float4x4(float4(1.0, 0.0, 0.0, uniformModelPos.value.x),
                                         float4(0.0, 1.0, 0.0, uniformModelPos.value.y),
                                         float4(0.0, 0.0, 1.0, uniformModelPos.value.z),
                                         float4(0.0, 0.0, 0.0, 1.0));

    const float cosX = cos(uniformModelRot.value.x);
    const float sinX = sin(uniformModelRot.value.x);
    float4x4 modelRotateXMatrix = float4x4(float4(1.0, 0.0, 0.0, 0.0),
                                           float4(0.0, cosX, -sinX, 0.0),
                                           float4(0.0, sinX, cosX, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosY = cos(uniformModelRot.value.y);
    const float sinY = sin(uniformModelRot.value.y);
    float4x4 modelRotateYMatrix = float4x4(float4(cosY, 0.0, sinY, 0.0),
                                           float4(0.0, 1.0, 0.0, 0.0),
                                           float4(-sinY, 0.0, cosY, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));

    const float cosZ = cos(uniformModelRot.value.z);
    const float sinZ = sin(uniformModelRot.value.z);
    float4x4 modelRotateZMatrix = float4x4(float4(cosZ, -sinZ, 0.0, 0.0),
                                           float4(sinZ, cosZ, 0.0, 0.0),
                                           float4(0.0, 0.0, 1.0, 0.0),
                                           float4(0.0, 0.0, 0.0, 1.0));
                                                
    float4x4 modelScaleMatrix = float4x4(float4(uniformModelScale.value.x, 0.0, 0.0, 0.0),
                                         float4(0.0, uniformModelScale.value.y, 0.0, 0.0),
                                         float4(0.0, 0.0, uniformModelScale.value.z, 0.0),
                                         float4(0.0, 0.0, 0.0, 1.0));
    
    float4x4 modelMatrix = uniformCustomMatrix.value * transpose(modelScaleMatrix * modelRotateXMatrix * modelRotateYMatrix * modelRotateZMatrix * modelTransMatrix);
    
    return modelMatrix;
}
