//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/14.
//

import SwiftyCreatives

public struct Empty: ReactiveGraphicsEntity {
    public var position: f3 = .zero
    public var rotation: f3 = .zero
    public var scale: f3 = .one
    public var entity: some ReactiveGraphicsEntity { self }
}
