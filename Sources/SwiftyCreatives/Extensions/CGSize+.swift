//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import CoreGraphics

extension CGSize: Comparable {
    public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        lhs.width * lhs.height < rhs.width * rhs.height
    }
}
