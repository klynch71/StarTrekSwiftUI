//
//  ComparableExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/18/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Returns the value clamped to the given closed range.
/// If the value is less than the lower bound, the lower bound is returned.
/// If the value is greater than the upper bound, the upper bound is returned.
/// Otherwise, the value itself is returned.
///
/// Useful for ensuring values stay within valid bounds (e.g. UI limits, physics constraints, game rules).
///
/// - Parameter limits: The range to clamp the value to.
/// - Returns: A value within the specified range.
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
