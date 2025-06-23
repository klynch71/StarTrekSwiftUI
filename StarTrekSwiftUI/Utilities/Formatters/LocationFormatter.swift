//
//  LocationFormatter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/12/25.
//

/// Used to format a `GalaxyLocation` into human-readable string representations.
struct LocationFormatter {
    
    /// Returns the sector coordinates relative to the quadrant containing the location, formatted as `(X, Y)`.
    ///
    /// - Parameter location: The `GalaxyLocation` whose sector coordinates are to be formatted.
    /// - Returns: A string representing the sector coordinates within the quadrant, e.g., "(3, 5)".
    static func localSector(_ location: GalaxyLocation) -> String {
        return "(\(location.sX), \(location.sY))"
    }
    
    /// Returns the quadrant coordinates of the location, formatted as `(X, Y)`.
    ///
    /// - Parameter location: The `GalaxyLocation` whose quadrant coordinates are to be formatted.
    /// - Returns: A string representing the quadrant coordinates, e.g., "(2, 4)".
    static func quadrant(_ location: GalaxyLocation) -> String {
        return "(\(location.qX), \(location.qY))"
    }
}
