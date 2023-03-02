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
        let copied = customMatrix.map { mat in
            let copy0 = mat.columns.0
            let copy1 = mat.columns.1
            let copy2 = mat.columns.2
            let copy3 = mat.columns.3
            return f4x4(copy0, copy1, copy2, copy3)
        }
        let copy = copied
        self.customMatrix = copy
    }
}
