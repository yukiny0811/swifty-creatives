//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/02/06.
//

import SVGVertexBuilder

public class SVGObj: SVG {
    
    public var triangulated: [[f3]] = []
    public var colors: [f4] = []

    public override init?(url: URL, maxDepth: Int = 1) async {
        await super.init(url: url, maxDepth: maxDepth)
        triangulated = triangulatedPaths.map {
            $0.map {
                f3($0.x, $0.y, 0)
            }
        }
        colors = triangulatedPaths.map { _ in
            f4(1, 1, 1, 1)
        }
    }

    @discardableResult
    public func setColors(colors: [f4]) -> Self {
        self.colors = colors
        return self
    }

    @discardableResult
    public func changeColors(_ process: (_ currentColors: [f4]) -> [f4]) -> Self {
        self.colors = process(self.colors)
        return self
    }

    @discardableResult
    public func makeAnchorCenter() -> Self {
        guard !triangulated.isEmpty else {
            return self
        }

        var sumX: Float = 0.0
        var sumY: Float = 0.0
        var totalPoints: Int = 0

        for triangle in triangulated {
            for vertex in triangle {
                sumX += vertex.x
                sumY += vertex.y
                totalPoints += 1
            }
        }

        let centroidX = sumX / Float(totalPoints)
        let centroidY = sumY / Float(totalPoints)

        for i in 0..<triangulated.count {
            for j in 0..<triangulated[i].count {
                triangulated[i][j].x -= centroidX
                triangulated[i][j].y -= centroidY
            }
        }

        return self
    }

    @discardableResult
    public func normalizeScale(imageAdjustOption: ImageAdjustOption) -> Self {
        guard !triangulated.isEmpty else {
            return self
        }

        var minX = Float.greatestFiniteMagnitude
        var minY = Float.greatestFiniteMagnitude
        var maxX = -Float.greatestFiniteMagnitude
        var maxY = -Float.greatestFiniteMagnitude

        for triangle in triangulated {
            for vertex in triangle {
                minX = min(minX, vertex.x)
                minY = min(minY, vertex.y)
                maxX = max(maxX, vertex.x)
                maxY = max(maxY, vertex.y)
            }
        }

        let width = maxX - minX
        let height = maxY - minY

        var scaleFactor: Float = 1.0

        switch imageAdjustOption {
        case .basedOnWidth:
            scaleFactor = 1.0 / width
        case .basedOnHeight:
            scaleFactor = 1.0 / height
        case .basedOnLonger:
            scaleFactor = 1.0 / max(width, height)
        }

        for i in 0..<triangulated.count {
            for j in 0..<triangulated[i].count {
                triangulated[i][j].x = (triangulated[i][j].x - minX) * scaleFactor
                triangulated[i][j].y = (triangulated[i][j].y - minY) * scaleFactor
            }
        }

        return self
    }
}
