//
//  SCPacket.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

public class SCPacket: FunctionBase {
    public var privateEncoder: SCEncoder?
    public var customMatrix: [f4x4] = []
    public init(privateEncoder: SCEncoder, customMatrix: f4x4) {
        self.privateEncoder = privateEncoder
        self.customMatrix.append(customMatrix)
    }
}
