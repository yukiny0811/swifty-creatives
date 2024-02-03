# SwiftyCreatives

[![Release](https://img.shields.io/github/v/release/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2Fswifty-creatives%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/swifty-creatives)
[![License](https://img.shields.io/github/license/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/swifty-creatives/blob/main/LICENSE)

__Creative coding framework for Swift.__   
Using Metal directly for rendering. Inspired by Processing. Supports visionOS.    

![outputFinalfinal](https://github.com/yukiny0811/swifty-creatives/assets/28947703/52d2d3f5-f69b-48f0-b77f-5db910615010)

## Requirements

- Swift5.9

## Supported Platforms

- macOS v14
- iOS v17
- visionOS v1
- tvOS v17

## Key Features

### Processing-like Syntax

You can easily create your graphics, using Swift Programming Language with the intuitive essence of Processing.    
I like how ```push()``` and ```pop()``` became super simple using Swift's trailing closure.

```.swift
import SwiftyCreatives

final class MySketch: Sketch {
    override func draw(encoder: SCEncoder) {
        let count = 20
        for i in 0..<count {
            color(0.75, Float(i) / 40, 1, 0.5)
            push {
                rotateY(Float.pi * 2 / Float(count) * Float(i))
                translate(10, 0, 0)
                box(0, 0, 0, 1, 1, 1)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        SketchView(MySketch())
    }
}
```
![スクリーンショット 2024-02-04 5 38 56](https://github.com/yukiny0811/swifty-creatives/assets/28947703/1d506879-6b23-460f-b7de-eb8a379bf2d1)

### Apple Vision Pro - Immersive Space

Supports visionOS! You can dive in to your sketch with Immersive Space rendering!

```.swift
ImmersiveSpace(id: "ImmersiveSpace") {
    CompositorLayer(configuration: ContentStageConfiguration()) { layerRenderer in
        let renderer = RendererBase.BlendMode.normalBlend.getRenderer(sketch: SampleSketch(), layerRenderer: layerRenderer)
        renderer.startRenderLoop()
    }
}
```

![ddd](https://github.com/yukiny0811/swifty-creatives/assets/28947703/e700c630-9f49-4f2e-99be-8963484edcc2)


### xib to 3D Space!

Create UIView with xib, and place it in 3D scene!    
UIButton can be connected with IBAction, and can be tapped in 3d space.

![outout](https://github.com/yukiny0811/swifty-creatives/assets/28947703/fbee6220-13f6-42d3-accf-3f43270d7251)

## Installation

Use Swift Package Manager.

```.swift
dependencies: [
    .package(url: "https://github.com/yukiny0811/swifty-creatives.git", branch: "main")
]
```
```.swift
.product(name: "SwiftyCreatives", package: "swifty-creatives")
```

### Features
- [x] Geometries
    - [x] Rectangle
    - [x] Circle
    - [x] Box
    - [x] Triangle
    - [x] Line
    - [x] BoldLine
    - [x] 3D Model (obj)
    - [x] Image
    - [x] Text
    - [x] 3D Text
    - [x] UIView Object (3d view created from xib, with interactive button)
    - [x] Mesh
    - [x] Vertex Buffer
- [x] Geometries with Hit Test (you can click or hover on it)
    - [x] HitTestableRect
    - [x] HitTestableBox
    - [x] HitTestableImg
- [x] Effects
    - [x] Fog
    - [x] Bloom
    - [x] Post Process (you can create your own)
- [x] Transforms
    - [x] Translate
    - [x] Rotate
    - [x] Scale
    - [x] Push & Pop
- [x] Others
    - [x] Creating original geomery class
|Geometry|Other Features|
|-|-|
|Rectangle (with hit test)|Perspective Camera|
|Circle|Orthographic Camera|
|Triangle|BlendMode(normal, add, alphaBlend)|
|Line|Lighting|
|Box (with hit test)|push/pop matrix|
|3D Model|can be used as UIView / NSView|
|Image (with hit test)|can be used as SwiftUI View|
|Text|Post Processing|
|UIViewObject (3d view with interactive button)|User-defined shaders|


![ExampleMacOSApp 2023年-02月-24日 17 11 06](https://user-images.githubusercontent.com/28947703/221126530-c362018e-325c-4747-8e57-c5e18ab7085d.gif)

![CheckMacOS 2023年-03月-01日 6 46 57](https://user-images.githubusercontent.com/28947703/221993495-7840a9e0-4de7-4c6c-8fef-ef3b9f53677f.gif)

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
            box(1, 1, 1)
            popMatrix()
        }
    }
}
```

### You can use SketchView as SwiftUI View
```View.swift
ZStack {
    SketchView(SampleSketch())
}
.background(.black)
```

<img width="863" alt="スクリーンショット 2023-02-03 7 51 34" src="https://user-images.githubusercontent.com/28947703/216469226-3f32ccee-c045-48c3-8fc0-0044ef7da891.png">

## Other Examples
- https://github.com/yukiny0811/sc-treeart
- https://github.com/yukiny0811/sc-stable-fluids
