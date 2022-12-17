# SwiftyCreatives

[![Release](https://img.shields.io/github/v/release/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![License](https://img.shields.io/github/license/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/blob/main/LICENSE)

Creative coding library for Swift.    
Using Metal directly for rendering.

![ExampleMacOSApp 2022年-12月-16日 18 08 41](https://user-images.githubusercontent.com/28947703/208063423-3ad00c20-1d1c-48b8-8996-2d43e1365fe4.gif)

## Sample Code
```MySketch.swift
// main sketch process
final class MySketch: SketchBase {
    var boxes: [Box] = []
    var elapsed: Float = 0.0
    func setup() {
        for _ in 0...100 {
            let box = Box()
            box.setColor(f4.randomPoint(0...1))
            box.setPos(f3.randomPoint(-10...10))
            box.setScale(f3.one * Float.random(in: 0.3...3))
            boxes.append(box)
        }
    }
    func update() {
        for b in boxes {
            b.setColor(f4(sin(elapsed), b.color.y, b.color.z, b.color.w))
        }
        elapsed += 0.01
    }
    func cameraProcess(camera: MainCamera<some CameraConfigBase>) {
        camera.rotateAroundY(0.01)
    }
    func draw(encoder: MTLRenderCommandEncoder) {
        for b in boxes {
            b.draw(encoder)
        }
    }
}
```

```Config.swift
// configs (optional)
final class MyDrawConfigNormal: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .normalBlend
}
final class MyDrawConfigAdd: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .add
}
final class MyDrawConfigAlpha: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .alphaBlend
}
```

```View.swift
// you can use SketchView as SwiftUI View
ZStack {
    Text("Swifty-Creatives Example")
        .font(.largeTitle)
    VStack {
        HStack {
            SketchView<MySketch, MainCameraConfig, MainDrawConfig>()
            SketchView<MySketch, MainCameraConfig, MainDrawConfig>()
            SketchView<MySketch, MainCameraConfig, MainDrawConfig>()
        }
        HStack {
            SketchView<MySketch, MainCameraConfig, MyDrawConfigNormal>()
            SketchView<MySketch, MainCameraConfig, MyDrawConfigAdd>()
            SketchView<MySketch, MainCameraConfig, MyDrawConfigAlpha>()
        }
    }
}
.background(.black)
```
