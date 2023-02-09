# SwiftyCreatives

[![Release](https://img.shields.io/github/v/release/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![License](https://img.shields.io/github/license/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/blob/main/LICENSE)

__Creative coding framework for Swift.__   
Using Metal directly for rendering.

![ExampleMacOSApp 2022年-12月-16日 18 08 41](https://user-images.githubusercontent.com/28947703/208063423-3ad00c20-1d1c-48b8-8996-2d43e1365fe4.gif)

## Features
- Geometry
    - 2D
        - Rectangle
        - Circle
        - Triangle
    - 3D
        - Box
        - 3D Model
    - Others
        - Image
        - Text
        - UIViewObject(3d view with interactive button)
- Camera
    - Perspective
    - Orthographic
- Blend Mode
    - normal
    - add
    - alpha
- Lighting
    - Phong's reflection model
- Functions
    - set color
    - set position
    - set rotation
    - set scale
    - push / pop matrix
- View
    - can be used as UIView / NSView
    - can be used as SwiftUI View

|||
|-|-|
|![QuickTime Player - Simulator Screen Recording - iPhone 14 Pro - 2023-02-02 at 00 18 08 mp4 2023年-02月-02日 0 20 50](https://user-images.githubusercontent.com/28947703/216084097-e4a9ec33-40dd-43bd-bc7a-a74b71e8caac.gif)|![QuickTime Player - Simulator Screen Recording - iPhone 14 Pro - 2023-02-02 at 00 21 57 mp4 2023年-02月-02日 0 22 17](https://user-images.githubusercontent.com/28947703/216084415-34797d43-9d42-402e-b305-53eb232e2641.gif)|

![ExampleMacOSApp 2023年-02月-02日 0 23 56](https://user-images.githubusercontent.com/28947703/216084840-585d4f38-dfb3-48bf-8f16-f8bc92badbb5.gif)

![QuickTime Player - 画面収録 2023-02-10 1 53 14 mov 2023年-02月-10日 2 55 14](https://user-images.githubusercontent.com/28947703/217897685-7a83bedf-5624-45e2-b566-9a05aab7c103.gif)


## Sample Code

### Main sketch process
```SampleSketch.swift
import SwiftyCreatives

final class SampleSketch: Sketch {
    override func draw(encoder: SCEncoder) {
        let count = 20
        for i in 0...count {
            color(1, Float(i) / 20, 0, 1)
            pushMatrix()
            rotateY(Float.pi * 2 / Float(count) * Float(i))
            translate(10, 0, 0)
            box(0, 0, 0, 1, 1, 1)
            popMatrix()
        }
    }
}
```

### You can use SketchView as SwiftUI View
```View.swift
ZStack {
    SketchView<MainCameraConfig, MainDrawConfig>(SampleSketch())
}
.background(.black)
```

<img width="863" alt="スクリーンショット 2023-02-03 7 51 34" src="https://user-images.githubusercontent.com/28947703/216469226-3f32ccee-c045-48c3-8fc0-0044ef7da891.png">

