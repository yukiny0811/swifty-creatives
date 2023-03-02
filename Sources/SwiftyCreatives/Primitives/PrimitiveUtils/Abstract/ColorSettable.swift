//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

public protocol ColorSettable: AnyObject {
    var color: f4 { get }
    @discardableResult func setColor(_ value: f4) -> Self
}
