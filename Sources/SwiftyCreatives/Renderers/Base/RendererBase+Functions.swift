//
//  RendererBase+Functions.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/26.
//

import Foundation

extension RendererBase {
    func calculateDeltaTime() {
        let date = Date()
        let elapsed: Float = Float(date.timeIntervalSince(savedDate))
        drawProcess.deltaTime = elapsed
        savedDate = date
    }
}
