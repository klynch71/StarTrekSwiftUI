//
//  Locatable.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/14/25.
//

import Foundation

/// A protocol for any object that occupies a location in the Galaxy.
///
/// Conforming types must be observable and identifiable,
/// and provide location tracking and a display name.
protocol Locatable: Identifiable, Hashable {
    
    /// The unique ID of this Locatble object
    var id: UUID { get }
    
    /// The current location of the object within the Galaxy.
    ///
    /// This can change over time, such as when the object moves.
    var location: GalaxyLocation { get set }
    
    /// The display name of the object, used for UI and logs.
    ///
    /// For example: "Starbase", "Klingon", or "Star".
    var name: String { get }
    
    /// create a copy of this Locatable object at the new Location
    func withLocation(_ newLocation: GalaxyLocation) -> Self
}

// MARK: extension
extension Locatable {
    
    ///provide a copy of the Locatable at the newLocation.
    func withLocation(_ newLocation: GalaxyLocation) -> Self {
        var copy = self
        copy.location = newLocation
        return copy
    }
}
