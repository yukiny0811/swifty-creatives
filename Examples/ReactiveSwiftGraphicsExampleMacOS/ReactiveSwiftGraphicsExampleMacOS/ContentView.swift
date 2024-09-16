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
