//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

import EasyMetalShader

@EMComputeShader
public class CornerRadiusPostProcessor {
    
    public var tex: MTLTexture?
    public var radius: Float = 10
    
    public var impl: String {
        "float width = tex.get_width();"
        "float height = tex.get_height();"
        
        "float4 color = tex.read(gid);"
        
        "if (gid.x < radius) {"
            "if (gid.y < radius) {"
                "if (distance(float2(gid.x, gid.y), float2(radius, radius)) > radius) {"
                    "color = float4(0);"
                "}"
            "} else if (gid.y > height - radius) {"
                "if (distance(float2(gid.x, gid.y), float2(radius, height - radius)) > radius) {"
                    "color = float4(0);"
                "}"
            "}"
        "} else if (gid.x > width - radius) {"
            "if (gid.y < radius) {"
                "if (distance(float2(gid.x, gid.y), float2(width - radius, radius)) > radius) {"
                    "color = float4(0);"
                "}"
            "} else if (gid.y > height - radius) {"
                "if (distance(float2(gid.x, gid.y), float2(width - radius, height - radius)) > radius) {"
                    "color = float4(0);"
                "}"
            "}"
        "}"
        
        "tex.write(color, gid);"
    }
    
    public var customMetalCode: String {
        ""
    }
}
