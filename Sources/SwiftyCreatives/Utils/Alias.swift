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
#elseif os(iOS) || os(visionOS) || os(tvOS)
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
#elseif os(iOS) || os(tvOS)
public typealias UISketchView = KitSketchView
#endif

// MARK: - Metal
import Metal
public typealias SCEncoder = MTLRenderCommandEncoder
public typealias SCCommandBuffer = MTLCommandBuffer

// MARK: - Font
#if os(macOS)
public typealias FontAlias = NSFont
#elseif os(iOS) || os(visionOS) || os(tvOS)
public typealias FontAlias = UIFont
#endif

// MARK: - Color
#if os(macOS)
public typealias ColorAlias = NSColor
#elseif os(iOS) || os(visionOS) || os(tvOS)
public typealias ColorAlias = UIColor
#endif
