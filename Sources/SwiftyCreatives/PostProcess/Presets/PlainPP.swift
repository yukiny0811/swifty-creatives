//
//  PlainPP.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

public class PlainPP: PostProcessor {
    public init() {
        super.init(functionName: "plainPostProcess", slowFunctionName: "plainPostProcess_Slow", bundle: .module)
        args = [0]
    }
}
