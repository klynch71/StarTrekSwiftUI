//
//  Course.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/27/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents a course (segmentDirection) in a 360° circle.
/// The circle is divided into `segments` equal parts. A course is defined by a segment-based
/// index from `1.0` (representing 0°) to `segments + 1` (which wraps back to 0°/1.0 again).
///
///                         3
///                      4     2
///                     5       1
///                      6     8
///                         7
///
/// A course can be initialized using a segment index, radians, or degrees.
struct Course: Equatable, Hashable {
    
    /// The number of segments in the circle
    static let segments = 8.0
    
    /// The size of a segment in radians
    static var segmentSizeRadians: Double {
        (2 * .pi) / segments
    }
    
    /// The course direction represented as a continuous segment index,
    /// where 1.0 corresponds to 0° and values can range up to `segments + 1`
    /// with fractional parts representing intermediate angles.
    let segmentDirection: Double
    
    /// The course equivalent in radians
    var radians: Double {return (segmentDirection - 1) * Course.segmentSizeRadians}
    
    /// The course equivalent in degrees
    var degrees: Double {return radians * 180 / Double.pi}
    
    /// Initializes using a segment-based direction.
    /// - Parameter direction: Segment index (1.0 to 8.0). Wraps around and normalizes if out of range.
    init(direction: Double) {
        self.segmentDirection = Course.normalizeSegmentDirection(direction)
    }
    
    
    /// Initializes using radians.
    /// - Parameter radians: Radian angle, normalized and mapped to the nearest segment.
    init(radians: Double) {
        self.segmentDirection = Course.radiansToSegmentDirection(radians)
    }
    
    /// Initializes using degrees.
    /// - Parameter degrees: Degree angle, converted to radians then mapped to a segment.
    init(degrees: Double) {
        let radians = degrees * Double.pi / 180
        self.init(radians: radians)
    }
    
    /// Normalize a continuous segmentDirection value to the range [1.0, segments + 1),
    /// wrapping values outside this range back into it.
    /// For example, `segmentDirection` of 9.2 with 8 segments wraps to 2.2.
    /// - Returns: a normalized segmentDirection
    static private func normalizeSegmentDirection(_ direction: Double) -> Double {
        var normalizedDirection = direction.truncatingRemainder(dividingBy: (Course.segments + 1))
        if normalizedDirection < 0 {
            normalizedDirection += Course.segments + 1
        }
        if normalizedDirection == 0 {
            normalizedDirection = 1.0
        }
        
        return normalizedDirection
    }
    
    /// Convert radians to a continuous segmentDirection in [1.0, segments + 1).
    static private func radiansToSegmentDirection(_ radians: Double) -> Double {
        let twoPi = 2 * Double.pi
        var result = radians.truncatingRemainder(dividingBy: twoPi)
        
        //convert negative radians to positive
        if result < 0 {
            result += twoPi
        }
        
        // Scale radians to (1.0 to COURSE.SEGMENTS + 1)
        var value = (result / Course.segmentSizeRadians) + 1.0
        if (value == Course.segments + 1) {
            value = 1.0
        }
        
        return value
    }
}
