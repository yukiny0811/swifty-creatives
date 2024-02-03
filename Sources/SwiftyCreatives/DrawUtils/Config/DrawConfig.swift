//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/03.
//

/// Config for draw config.
public class DrawConfig {
    
    public var contentScaleFactor: Int
    public var frameRate: Int
    
    init(contentScaleFactor: Int, frameRate: Int) {
        self.contentScaleFactor = contentScaleFactor
        self.frameRate = frameRate
    }
}
