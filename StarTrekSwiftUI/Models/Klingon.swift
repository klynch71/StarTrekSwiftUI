//
//  Klingon.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/16/25.
//

import Foundation

/// A Klingon warship in the galaxy.
struct Klingon: Locatable {
    
    /// Default starting energy for a Klingon.
    static let baseEnergy = 200
    
    /// Unique identifier for this Klingon.
    let id: UUID
    
    /// Current location of the Klingon in the Galaxy.
    var location: GalaxyLocation
    
    /// Current energy level of the Klingon warship.
    let energy: Int
    
    /// Display name for this object (always "Klingon").
    var name: String { "Klingon" }
    
    /// Initializes a Klingon with a given location and energy.
    init(id: UUID, location: GalaxyLocation, energy: Int) {
        self.id = id
        self.location = location
        self.energy = energy
    }
    
    /// return a Klingon identical to this one except for the energy level
    func withEnergy(_ newEnergy: Int) -> Klingon {
        return Klingon(id: id, location: location, energy: newEnergy)
    }

    // MARK: - Equatable

    /// Returns true if two Klingons have the same ID.
    static func == (lhs: Klingon, rhs: Klingon) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Hashable

    /// Hashes the Klingon's ID.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

