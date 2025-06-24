//
//  ShipSystemDamageEvent.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/21/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents a damage-related event in the game. This may describe a change
/// to a single ship system or indicate that all systems were repaired.
enum DamageEvent {
    /// A specific system was damaged, repaired, or remained unchanged.
    case system(ShipSystemDamageEvent)
    
    /// All ship systems were repaired at once (e.g., due to docking).
    case allRepaired
}

/// Represents the nature of a damage change to a system.
enum DamageChangeType {
    /// The system took additional damage.
    case damaged
    
    /// The system was repaired (damage value decreased).
    case repaired
    
    /// The system's damage level did not change.
    case unchanged
}

/// Encapsulates a change in the damage state of a single ship system.
struct ShipSystemDamageEvent {
    /// The system whose damage state changed.
    let system: ShipSystem
    
    /// The damage level before the change.
    let oldDamage: Int
    
    /// The damage level after the change.
    let newDamage: Int
    
    /// The nature of the change (damaged, repaired, or unchanged).
    let changeType: DamageChangeType

    /// Initializes a new damage event for a ship system, automatically
    /// determining the type of change based on old and new damage values.
    ///
    /// - Parameters:
    ///   - system: The affected ship system.
    ///   - oldDamage: The previous damage level.
    ///   - newDamage: The new damage level.
    init(system: ShipSystem, oldDamage: Int, newDamage: Int) {
        self.system = system
        self.oldDamage = oldDamage
        self.newDamage = newDamage

        if newDamage > oldDamage {
            self.changeType = .damaged
        } else if newDamage < oldDamage {
            self.changeType = .repaired
        } else {
            self.changeType = .unchanged
        }
    }
}
