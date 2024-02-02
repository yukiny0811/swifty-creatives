//
//  TouchableMTKView+Utils.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

import MetalKit

#if !os(visionOS)

extension TouchableMTKView {
    func checkIfExceedsPolarSpacing(rad: Float, polarSpacing: Float) -> Bool {
        let mockedMainMatrix = renderer.camera.mock_rotateAroundVisibleX(rad)
        let detectionValue = mockedMainMatrix.columns.1.y
        if detectionValue < polarSpacing {
            return true
        }
        return false
    }
}

#endif
