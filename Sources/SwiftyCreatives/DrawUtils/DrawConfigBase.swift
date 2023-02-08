//
//  DrawConfigBase.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

public protocol DrawConfigBase {
    static var contentScaleFactor: Int { get }
    static var blendMode: BlendMode { get }
    static var clearOnUpdate: Bool { get }
}
