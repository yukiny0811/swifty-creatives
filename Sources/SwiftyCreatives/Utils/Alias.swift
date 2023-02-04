//
//  Alias.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/10.
//

// MARK: - SwiftUI
import SwiftUI

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

// MARK: - simd
import simd

public typealias f2 = simd_float2
public typealias f3 = simd_float3
public typealias f4 = simd_float4
public typealias f4x4 = simd_float4x4

// MARK: - View
#if os(macOS)
public typealias NSSketchView = KitSketchView
#elseif os(iOS)
public typealias UISketchView = KitSketchView
#endif

// MARK: - Metal
import Metal
public typealias SCEncoder = MTLRenderCommandEncoder
