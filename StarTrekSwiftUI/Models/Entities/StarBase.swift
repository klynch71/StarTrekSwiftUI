//
//  Starbase.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/11/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import Foundation

/// Represents a Starbase within the galaxy. Starbases serve as support structures for the Enterprise.
struct Starbase : Locatable {
    
    /// A unique identifier for this starbase.
    let id: UUID
    
    /// The current location of the starbase within the galaxy.
    var location: GalaxyLocation
    
    /// The display name of the starbase.
    var name: String { "Starbase" }
    
    /// Creates a new Starbase at the specified location.
    /// - Parameter location: The initial location of the starbase in the galaxy.
    init(id: UUID, location: GalaxyLocation) {
        self.id = id
        self.location = location
    }
    
    // MARK: - Equatable
    
    /// Compares two starbases for equality based on their unique identifiers.
    static func == (lhs: Starbase, rhs: Starbase) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Hashable
    
    /// Hashes the essential components of the starbase.
    /// Required to use Starbase in sets or as dictionary keys.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
