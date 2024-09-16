//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/09/16.
//

import Foundation

@attached(
    peer,
    names: arbitrary
)
public macro DrawFunction() = #externalMacro(module: "SwiftyCreativesMacro", type: "DrawFunction")
