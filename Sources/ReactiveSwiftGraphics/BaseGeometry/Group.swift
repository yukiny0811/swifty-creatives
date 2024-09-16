//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives

public struct Group: ReactiveGraphicsEntity {

    public var position: f3 = .zero
    public var rotation: f3 = .zero
    public var scale: f3 = .one

    let entities: [any ReactiveGraphicsEntity]
    public init(@ReactiveGraphicsBuilder _ entityBuilder: @escaping () -> [any ReactiveGraphicsEntity]) {
        self.entities = entityBuilder()
    }
    //    init(@ReactiveGraphicsBuilder _ entityBuilder: @escaping () -> some ReactiveGraphicsEntity) {
    //        self.entities = [entityBuilder()]
    //    }
    public var entity: some ReactiveGraphicsEntity {
        Empty()
    }

    public static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.entities.elementsEqual(rhs.entities, by: { $0.isEqual(to: $1) })
    }

}
