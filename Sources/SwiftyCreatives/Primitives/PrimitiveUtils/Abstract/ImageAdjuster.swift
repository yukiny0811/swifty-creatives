//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/03.
//

public struct ImageAdjuster {
    public static func adjustedScale(width: Float, height: Float, with option: ImageAdjustOption) -> f3 {
        switch option {
        case .basedOnWidth:
            return f3(1, height / width, 1)
        case .basedOnHeight:
            return f3(width / height, 1, 1)
        case .basedOnLonger:
            let longer = max(width, height)
            return f3(width / longer, height / longer, 1)
        }
    }
}
