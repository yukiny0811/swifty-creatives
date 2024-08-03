//
//  Feature1.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/08/03.
//

import SwiftyCreatives
import SwiftUI

final class Feature1: Sketch {

    enum StandardGeometry: Int {
        case rect
        case box
        case circle
        case triangle
        case line
        case boldline
        case image
        case svg
        mutating func toggleNext() {
            self = StandardGeometry(rawValue: self.rawValue + 1) ?? StandardGeometry(rawValue: 0)!
        }
    }

    var frameCount = 0
    var currentGeometry: StandardGeometry = StandardGeometry(rawValue: 0)!

    let imgObj = Img().load(name: "apple", bundle: nil).adjustScale(with: .basedOnWidth).multiplyScale(1.2)
    var svgObj: SVGObj?

    override init() {
        super.init()
        DispatchQueue.main.async {
            Task {
                self.svgObj = await SVGObj(url: Bundle.main.url(forResource: "apple", withExtension: "svg")!)?
                    .normalizeScale(imageAdjustOption: .basedOnWidth)
                    .makeAnchorCenter()
                    .changeColors { currentColors in
                        return currentColors.map { _ in f4.randomPoint(0...1) }
                    }
            }
        }
    }

    override func update(camera: MainCamera) {
        frameCount += 1
        if frameCount.isMultiple(of: 300) {
            currentGeometry.toggleNext()
        }
    }

    override func draw(encoder: SCEncoder) {
        color(1, 1, 1, 1)

        switch currentGeometry {
        case .rect:
            rect(1)
        case .box:
            box(1)
        case .circle:
            circle(1)
        case .triangle:
            triangle(1)
        case .line:
            line(.zero, .one)
        case .boldline:
            boldline(.zero, .one, width: 0.1)
        case .image:
            img(imgObj)
        case .svg:
            if let svgObj {
                svg(svgObj)
            }
        }
    }

    struct VIEW: View {
        var body: some View {
            VStack {
                Text("standard geometries")
                SketchView(Feature1())
            }
        }
    }
}
