//
//  BindingExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/7/25.
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
