//
//  SnapshotTestUtil.swift
//  
//
//  Created by Yuki Kuwashima on 2023/03/27.
//

import XCTest
import Metal
@testable import SwiftyCreatives

enum SnapshotTestUtil {
    static let isRecording = false
    static func testGPU() throws {
        try XCTSkipIf(MTLCreateSystemDefaultDevice() == nil)
    }
}
