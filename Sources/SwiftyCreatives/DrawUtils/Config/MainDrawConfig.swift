//
//  MainDrawConfig.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

#if !os(visionOS)

// Default draw config.
public class MainDrawConfig: DrawConfigBase {
    public static let contentScaleFactor: Int = 3
    public static let blendMode: BlendMode = .alphaBlend
    public static let clearOnUpdate: Bool = true
    public static let frameRate: Int = 120
}

#endif
