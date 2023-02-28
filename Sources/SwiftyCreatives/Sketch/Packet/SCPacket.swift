//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

public class SCPacket {
    private(set) public var privateEncoder: SCEncoder?
    internal(set) public var customMatrix: [f4x4]
    public init(privateEncoder: SCEncoder, customMatrix: [f4x4]) {
        self.privateEncoder = privateEncoder
        self.customMatrix = customMatrix
    }
}
