//
//  Sample8.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2023/02/10.
//

import SwiftyCreatives
import CoreGraphics
import AppKit

final class Sample8: Sketch {
    var tree = "F"
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, -20, -40)
    }
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    override func draw(encoder: SCEncoder) {
        for t in tree {
            compile(char: t)
        }
    }
    override func keyDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {
        var currentTree = ""
        for t in tree {
            if t == "F" {
                currentTree += "FyF+[+FyF-yB]-y[-yF+YP]"
            } else {
                currentTree += String(t)
            }
        }
        tree = currentTree
    }
    func compile(char: Character) {
        switch char {
        case "B":
            color(0.5, 0.5, 1.0, 1.0)
            boldline(0, 0, 0, 0, 1, 0, width: 0.1)
            translate(0, 1, 0)
        case "P":
            color(1.0, 0.3, 1.0, 1.0)
            boldline(0, 0, 0, 0, 1, 0, width: 0.1)
            translate(0, 1, 0)
        case "F":
            color(0.9, 1.0, 1.0, 0.8)
            boldline(0, 0, 0, 0, 1, 0, width: 0.1)
            translate(0, 1, 0)
        case "+":
            rotateZ(0.3)
        case "-":
            rotateZ(-0.3)
        case "[":
            pushMatrix()
        case "]":
            popMatrix()
        case "y":
            rotateY(0.15)
        case "Y":
            rotateY(-0.15)
        default:
            break
        }
    }
}
