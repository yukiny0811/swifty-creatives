//
//  AdvancedSample.swift
//  ExampleMacOSApp
//
//  Created by Yuki Kuwashima on 2024/10/01.
//

import SwiftyCreatives

class AdvancedSample: AdvancedSketch {
    let model = ModelObject3D().loadModel(url: Bundle.main.url(forResource: "sphere", withExtension: "obj")!, vertexDescriptor: RenderCore.sharedVertexDescriptor, textureLoader: ShaderCore.textureLoader)
    override func setupCamera(camera: MainCamera) {
        camera.setTranslate(0, 0, -20)
    }
    override func draw(encoder: any MTLRenderCommandEncoder) {
        model.render(renderEncoder: encoder, pos: .zero, rot: .zero, scale: .one)
    }
    override func postProcess(texture: any MTLTexture, commandBuffer: any MTLCommandBuffer) {

    }
}
