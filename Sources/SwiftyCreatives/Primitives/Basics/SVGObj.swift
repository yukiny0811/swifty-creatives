//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import SVGVertexBuilder

public class SVGObj: SVG {
    
    public var triangulated: [[f3]] = []
    
    public override init?(url: URL) async {
        await super.init(url: url)
        triangulated = triangulatedPaths.map {
            $0.map {
                f3($0.x, $0.y, 0)
            }
        }
    }
}
