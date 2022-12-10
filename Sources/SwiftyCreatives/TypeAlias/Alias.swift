//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/10.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import SwiftUI

final class Alias {
    
    #if os(macOS)
    typealias ViewRepresentable = NSViewRepresentable
    #elseif os(iOS)
    typealias ViewRepresentable = UIViewRepresentable
    #endif
        
}
