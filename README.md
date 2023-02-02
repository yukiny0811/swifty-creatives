# SwiftyCreatives

[![Release](https://img.shields.io/github/v/release/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![License](https://img.shields.io/github/license/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/blob/main/LICENSE)

__Creative coding library for Swift.__   
Using Metal directly for rendering.

![ExampleMacOSApp 2022年-12月-16日 18 08 41](https://user-images.githubusercontent.com/28947703/208063423-3ad00c20-1d1c-48b8-8996-2d43e1365fe4.gif)

|||
|-|-|
|![QuickTime Player - Simulator Screen Recording - iPhone 14 Pro - 2023-02-02 at 00 18 08 mp4 2023年-02月-02日 0 20 50](https://user-images.githubusercontent.com/28947703/216084097-e4a9ec33-40dd-43bd-bc7a-a74b71e8caac.gif)|![QuickTime Player - Simulator Screen Recording - iPhone 14 Pro - 2023-02-02 at 00 21 57 mp4 2023年-02月-02日 0 22 17](https://user-images.githubusercontent.com/28947703/216084415-34797d43-9d42-402e-b305-53eb232e2641.gif)|

![ExampleMacOSApp 2023年-02月-02日 0 23 56](https://user-images.githubusercontent.com/28947703/216084840-585d4f38-dfb3-48bf-8f16-f8bc92badbb5.gif)


## Sample Code

### Main sketch process
```SampleSketch.swift
import Metal
import SwiftyCreatives

final class SampleSketch: Sketch {
    var objects: [Box] = []
    override init() {
        super.init()
        for _ in 0..<100 {
            let box = Box()
            box
                .setPos(f3.randomPoint(-7...7))
                .setColor(f4.randomPoint(0...1))
                .setScale(f3.randomPoint(1...2))
            objects.append(box)
        }
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: MTLRenderCommandEncoder) {
        for o in objects {
            o.draw(encoder)
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
