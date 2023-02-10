//
//  Material.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

public struct Material {
    public init(ambient: f3, diffuse: f3, specular: f3, shininess: Float) {
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.shininess = shininess
    }
    public var ambient: f3
    public var diffuse: f3
    public var specular: f3
    public var shininess: Float
    public static var memorySize: Int {
        return MemoryLayout<Self>.stride
    }
}
