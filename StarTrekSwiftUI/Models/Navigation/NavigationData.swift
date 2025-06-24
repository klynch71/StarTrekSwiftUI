//
//  NavigationData.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents navigation data including course and distance.
///
/// - Parameters:
///   - course: The heading for travel.
///   - distance: The distance to move along that heading.

struct NavigationData: Equatable, Hashable {
    
    /// The direction or heading for navigation like a compass.
    let course: Course
    
    /// The distance to travel along the specified course.
    let distance: Double
    
    /// Initializes a new `NavigationData` instance.
    ///
    /// - Parameters:
    /// - course: The direction of travel.
    /// - distance: The amount of distance to move along the given course.
    init(course: Course, distance: Double) {
        self.course = course
        self.distance = distance
    }
}
