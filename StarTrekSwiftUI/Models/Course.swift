//
//  Course.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/27/25.
//

import Foundation

/*
 Reporesents a Course for the game which is a direction on a 360 degree circle.
 direction is given as a number from 1.0 (representing 0 degrees) to SEGMENTS + 1 which
 represents 360 degrees.  Thus, if SEGMENTS = 8, we have:
 
                          3
                       4     2
                      5       1
                       6     8
                          7
 */
struct Course {
    static let SEGMENTS = 8.0
    let direction: Double
    var radians: Double {return (self.direction - 1) / Course.SEGMENTS * 2 * Double.pi}
    var degrees: Double {return self.radians * 180 / Double.pi}
    
    /*
     init with directional number
     */
    init(direction: Double) {
        var normalizedDirection = direction.truncatingRemainder(dividingBy: (Course.SEGMENTS+1))
        if normalizedDirection < 0 {
            normalizedDirection += Course.SEGMENTS+1
        }
        if normalizedDirection == 0 {
            normalizedDirection = 1.0
        }
        self.direction = normalizedDirection
    }
    
    
    /*
     init with radians
     */
    init(radians: Double) {
        let twoPi = 2 * Double.pi
        var result = radians.truncatingRemainder(dividingBy: twoPi)
        
        //convert negative radians to positive
        if result < 0 {
            result += twoPi
        }
        
        // Scale radians to [1.0 to COURSE.SEGMENTS + 1)
        let segmentSize = (2 * Double.pi) / Course.SEGMENTS
        var value = (result / segmentSize) + 1.0
        if (value == Course.SEGMENTS + 1) {
            value = 1.0
        }

        self.direction = value
    }
    
    /*
     init with degrees
     */
    init(degrees: Double) {
        let radians = degrees * Double.pi / 180
        self.init(radians: radians)
    }
}
