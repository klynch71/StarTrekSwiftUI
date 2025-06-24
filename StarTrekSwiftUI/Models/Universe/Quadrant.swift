//
//  Quadrant.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/13/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents a quadrant within the Galaxy grid.
///
/// Each quadrant is uniquely identified by an integer ID and contains a fixed number of sectors.
/// Sector IDs are assigned linearly across quadrants:
/// - Quadrant 0: sectors 0–63
/// - Quadrant 1: sectors 64–127
/// - etc.
///
/// Quadrant names are generated using a combination of a star system name and a Roman numeral suffix.
struct Quadrant: ExpressibleByIntegerLiteral, Identifiable, Equatable, Hashable {
    
    /// The number of sectors contained within a single quadrant.
    static let sectorsPerQuadrant = Galaxy.sectorCols * Galaxy.sectorRows
    
    /// The unique integer ID of this quadrant.
    let id : Int
    
    /// The base name of the star system this quadrant is part of.
    /// Calculated based on the quadrant's ID.
    var starSystemName: String {return Galaxy.starSystemNames[id / Galaxy.quadrantSuffixes.count]}
    
    /// The unique name of the quadrant, composed of the star system name and a Roman numeral suffix.
    /// Example: `"Rigel IV"`
    var name: String {
        "\(starSystemName)\(Galaxy.quadrantSuffixes[id % Galaxy.quadrantSuffixes.count])"
    }
    
    /// Returns all sectors that belong to this quadrant.
    /// Sector IDs are continuous and range from `firstSector...lastSector`.
    var sectors: Array<Sector> {
        let firstSector = Quadrant.sectorsPerQuadrant * id;
        let lastSector = firstSector + Quadrant.sectorsPerQuadrant - 1;
        return Array(firstSector...lastSector).map {Sector($0)};
    }
    
    /// Initializes a quadrant with a given integer literal.
    /// Enables shorthand syntax: `let q: Quadrant = 3`
    ///
    /// - Parameter val: A valid quadrant ID (must be within galaxy bounds).
    init(integerLiteral val: Int) {
        precondition(val >= 0, "Quadrant ID must be non-negative")
        precondition(val < Galaxy.quadrantCols * Galaxy.quadrantRows, "Quadrant ID exceeds total number of quadrants")
         self.id = val
    }
    
    /// Initializes a quadrant from an integer ID.
    ///
    /// - Parameter val: A valid quadrant ID.
    init(_ val: Int) {
        self.init(integerLiteral: val);
    }
}
