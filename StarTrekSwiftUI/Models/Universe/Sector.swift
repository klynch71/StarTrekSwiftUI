//
//  Sector.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/13/25.
//

/// Represents a unique location (sector) within a quadrant of the galaxy grid.
/// Each `Sector` is uniquely identified by an integer ID. The galaxy is divided into quadrants,
/// and each quadrant contains a fixed number of sectors.
///
/// - Important:
///   Sector IDs must be in the valid range:
///   `0...(Galaxy.quadrantCols * Galaxy.quadrantRows * Quadrant.sectorsPerQuadrant - 1)
struct Sector: ExpressibleByIntegerLiteral, Identifiable, Equatable, Hashable {
    
    /// The unique integer identifier for this sector.
    /// Used for efficient indexing and equality comparison.
    let id: Int
    
    /// Initializes a `Sector` using an integer literal.
    /// This enables syntax like `let sector: Sector = 42`.
    ///
    /// - Parameter val: The sector ID. Must be within valid bounds.
    init(integerLiteral val: Int) {
        precondition(val >= 0, "Sector ID must be non-negative")
        precondition(val < (Galaxy.quadrantCols * Galaxy.quadrantRows) * Quadrant.sectorsPerQuadrant, "Sector ID exceeds total number of sectors")
        self.id = val
    }
    
    /// Initializes a `Sector` from a given integer value.
    ///
    /// - Parameter val: The sector ID. Must be within valid bounds.
    init(_ val: Int) {
        self.init(integerLiteral: val);
    }
}
