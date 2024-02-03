//
//  MainDrawConfig.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

#if !os(visionOS)

// Default draw config.
public class DefaultDrawConfig: DrawConfig {
    public override init(
        contentScaleFactor: Int = 3,
        frameRate: Int = 120
    ) {
        super.init(
            contentScaleFactor: contentScaleFactor,
            frameRate: frameRate
        )
    }
}

#endif
