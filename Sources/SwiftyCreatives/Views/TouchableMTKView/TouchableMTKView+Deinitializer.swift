//
//  TouchableMTKView+Deinitializer.swift
//  
//
//  Created by Yuki Kuwashima on 2023/05/16.
//

import MetalKit

#if !os(visionOS)

extension TouchableMTKView {
    func deinitView() {
        #if os(iOS)
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer)
            }
        }
        #endif
    }
}

#endif
