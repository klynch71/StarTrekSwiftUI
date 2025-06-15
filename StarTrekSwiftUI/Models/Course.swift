//
//  Course.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/27/25.
//

import Foundation

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
    
    /// The course direction as it pertains to the segments.
    let segmentDirection: Double
    
    /// The course equivalent in radians
    var radians: Double {return (segmentDirection - 1) * Course.segmentSizeRadians}
    
    /// The course equivalent in degrees
    var degrees: Double {return radians * 180 / Double.pi}
    
    /// Initializes using a segment-based direction.
    /// - Parameter direction: Segment index (1.0 to 8.0). Wraps around and normalizes if out of range.
    init(direction: Double) {
        var normalizedDirection = direction.truncatingRemainder(dividingBy: (Course.segments + 1))
        if normalizedDirection < 0 {
            normalizedDirection += Course.segments + 1
        }
        if normalizedDirection == 0 {
            normalizedDirection = 1.0
        }
        self.segmentDirection = normalizedDirection
    }
    
    
    /// Initializes using radians.
    /// - Parameter radians: Radian angle, normalized and mapped to the nearest segment.
    init(radians: Double) {
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

        self.segmentDirection = value
    }
    
    /// Initializes using degrees.
    /// - Parameter degrees: Degree angle, converted to radians then mapped to a segment.
    init(degrees: Double) {
        let radians = degrees * Double.pi / 180
        self.init(radians: radians)
    }
}
