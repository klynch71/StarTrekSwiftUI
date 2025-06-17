//
//  CombatEvent.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/17/25.
//

import Foundation

/// The possible effect of a combat action.
enum CombatEffect: Equatable {
    case noAmmo                     // No ammunition available
    case noTargets                  // No valid targets in range
    case systemDamaged(ShipSystem)  // system is damaged
    case fired                      // Attack fired, result pending
    case missed                     // Attack missed the target
    case hit                        // Attack hit the target
    case destroyed                  // Target was destroyed
    case absorbed                   // Energy absorbed (e.g. by a Star)
    case protected                  // Attack blocked (e.g. by a Starbase)
}

/// The type of attack used during combat.
enum AttackType: Equatable {
    case phasers
    case torpedo
}

/// Represents the final outcome of a combat interaction.
struct CombatEvent {
    /// The attacking object.
    let attacker: any Locatable

    /// The type of attack used.
    let attackType: AttackType

    /// The target of the attack (if any).
    let target: (any Locatable)?

    /// The result of the attack.
    let effect: CombatEffect
}
