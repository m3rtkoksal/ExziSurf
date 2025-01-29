//
//  ItemHeightPreferenceKey.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//
import SwiftUI

struct ItemHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [CGFloat] = []
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

