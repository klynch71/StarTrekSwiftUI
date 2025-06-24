//
//  BindingExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/7/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// An extension to binding to provide value clamping
extension Binding where Value == Int {
    func clamped(to limit: @escaping () -> Int) -> Binding<Int> {
        Binding<Int>(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = Swift.min(Swift.max(0, newValue), Swift.max(0, limit()))
            }
        )
    }
}
