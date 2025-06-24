//
//  Star.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/11/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import Foundation

/// Represents a star located within the galaxy.
/// Stars are celestial objects that may affect combat outcomes (e.g., absorbing torpedo energy).
struct Star : Locatable {
    
    /// A unique identifier for this star.
    let id: UUID
    
    /// The current location of the star within the galaxy.
    var location: GalaxyLocation
    
    /// The display name of the star.
    var name: String { "Star" }
    
    /// Initializes a new Star at the specified galaxy location.
     /// - Parameter location: The location this star occupies within the galaxy.
    init(id: UUID, location: GalaxyLocation) {
        self.id = id
        self.location = location
    }
    
    // MARK: - Equatable

    /// Compares two stars for equality based on their unique identifiers.
    static func == (lhs: Star, rhs: Star) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Hashable

    /// Hashes the essential components of the star for set and dictionary operations.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
