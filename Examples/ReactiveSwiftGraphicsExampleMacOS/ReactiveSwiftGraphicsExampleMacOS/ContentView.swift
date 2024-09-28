//
//  ContentView.swift
//  ReactiveSwiftGraphicsExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import SwiftUI
import ReactiveSwiftGraphics

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ReactiveGraphicsScene {
                for _ in 0...30 {
                    MyBox(position: f3.randomPoint(-20...20))
                }
                MyBox(position: f3.randomPoint(-20...20))
                MyModel3D(position: .zero, rotation: .zero)
            }
            .background(.black)
        }
    }
}

struct MyBox: ReactiveGraphicsEntity {

    @GraphicsStateAnimatable var position: f3
    @GraphicsStateAnimatable var color: f4 = f4(1, 1, 1, 1)
    var rotation: f3 = .randomPoint(0...Float.pi*2)
    var scale: f3 = .one
    @GraphicsState var hovering = false

    var entity: some ReactiveGraphicsEntity {
        Box(position: position, rotation: rotation, color: color)
            .enableRayInteraction()
            .onTap {
                $position.animate(to: f3.randomPoint(-10...10), duration: 1)
            }
            .hovering($hovering)
            .onChange(of: $hovering) {
                if hovering {
                    $color.animate(to: f4(0, 1, 0, 1), duration: 1)
                } else {
                    $color.animate(to: f4(1, 1, 1, 1), duration: 1)
                }
            }
    }

}

struct MyModel3D: ReactiveGraphicsEntity {
    @GraphicsState var position: SwiftyCreatives.f3
    var rotation: SwiftyCreatives.f3
    var scale: SwiftyCreatives.f3 = .one * 0.25

    @GraphicsStateAnimatable var color: f4 = .one
    @GraphicsState var hovering = false

    var entity: some ReactiveGraphicsEntity {
        Model3D(
            modelURL: Bundle.main.url(forResource: "sphere", withExtension: "obj")!,
            position: position,
            rotation: rotation,
            scale: scale,
            color: color,
            collider: .sphere(radius: 1)
        )
        .enableRayInteraction()
        .onTap {
            position = f3.randomPoint(-20...20)
        }
        .hovering($hovering)
        .onChange(of: $hovering) {
            if hovering {
                $color.animate(to: f4(0, 1, 0, 1), duration: 1)
            } else {
                $color.animate(to: f4(1, 1, 1, 1), duration: 1)
            }
        }
    }
}
