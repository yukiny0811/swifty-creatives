//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/04.
//

import Foundation

@SketchObject
public class Box {
    
    public var pos: f3
    public var col: f4
    public var scale: f3
    
    public init(pos: f3, col: f4, scale: f3) {
        self.pos = pos
        self.col = col
        self.scale = scale
    }
    
    public func draw() {
        color(col)
        box(pos, scale)
    }
}
