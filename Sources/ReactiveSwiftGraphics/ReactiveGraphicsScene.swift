//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives
import SwiftUI

public struct ReactiveGraphicsScene: View {

    @StateObject var sketch: ReactiveGraphicsSketch = .init(entity: Group{ Empty() })
    let entity: Group

    public init(@ReactiveGraphicsBuilder _ entityBuilder: @escaping () -> some ReactiveGraphicsEntity) {
        self.entity = Group { entityBuilder() }
    }
    public init(@ReactiveGraphicsBuilder _ entityBuilder: @escaping () -> [any ReactiveGraphicsEntity]) {
        let builded = entityBuilder()
        self.entity = Group { builded }
    }

    public var body: some View {
        SketchView(sketch)
            .onAppear {
                self.sketch.entity = self.entity
            }
            .onChange(of: entity) {
                self.sketch.entity = self.entity
            }
    }
}
