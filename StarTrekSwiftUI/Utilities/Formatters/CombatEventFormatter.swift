//
//  CombatEventFormatter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/9/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Formats a CombatEvent into a user-friendly message for display.
struct CombatEventFormatter {
    
    /// Generates a formatted message string based on the outcome of a combat event.
    ///
    /// - Parameter event: The `CombatEvent` to format.
    /// - Returns: A `String` message describing the event outcome for the UI.
    static func message(for event: CombatEvent) -> String {
        let targetName = event.target?.name ?? "Unknown target"
        let targetLocation = event.target.map { LocationFormatter.localSector($0.location) } ?? ""
        
        switch event.effect {
            
        ///No enemies available to target.
        case .noTargets:
            return "There are no enemies in the current quadrant."
            
        /// The Enterprise lacks ammo or phaser energy.
        case .noAmmo:
            return event.attackType == .torpedo
                ? "Enterprise has no photon torpedoes."
                : "Phaser energy is too low for a successful attack."
            
        case .systemDamaged(let system):
            return "System damaged: \(system.displayName).  Repairs are underway"
            
        /// A weapon was fired, but the effect is still to be resolved.
        case .fired:
            return event.attackType == .phasers
                ? "Firing phasers..."
                : "Firing photon torpedo..."
            
        /// Torpedo missed its intended target.
        case .missed:
            return "Torpedo missed the target."
            
        /// Torpedo impacted a star and was absorbed with no effect.
        case .absorbed:
            return "Torpedo energy absorbed by star at sector \(targetLocation)."
            
        /// The target was destroyed.
        case .destroyed:
            return "\(targetName) destroyed at sector \(targetLocation)."
            
        /// The Enterprise is currently protected by a nearby starbase.
        case .protected:
            return "Enterprise is protected by the nearby starbase."
            
        /// A successful hit occurred; show target-specific information.
        case .hit:
            if let enterprise = event.target as? Enterprise {
                // Hit on the Enterprise itself
                return "Enterprise hit by ship at \(LocationFormatter.localSector(event.attacker.location)). Shields now at \(String(enterprise.shieldEnergy))."
            } else {
                // Hit on a non-Enterprise target (e.g., Klingon)
                if let klingon = event.target as? Klingon {
                    return klingon.name + " hit at sector \(targetLocation).  Klingon shield strength dropped to \(String(klingon.energy))."
                }
                return targetName + " hit at sector \(targetLocation)."
            }
        }
    }
}
