//
//  CGSize+.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import CoreGraphics

extension CGSize: AdditiveArithmetic {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self.init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self.init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    public static func * (lhs: Self, rhs: CGFloat) -> Self {
        return Self.init(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    public static func * (lhs: Self, rhs: Float) -> Self {
        return Self.init(width: lhs.width * CGFloat(rhs), height: lhs.height * CGFloat(rhs))
    }
    
    public static func / (lhs: Self, rhs: CGFloat) -> Self {
        return Self.init(width: lhs.width / rhs, height: lhs.height / rhs)
    }
    
    public static func / (lhs: Self, rhs: Float) -> Self {
        return Self.init(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
    }
}
