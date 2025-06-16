//
//  CombatEvent.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/7/25.
//


/// The possible outcomes of a combat action.
enum CombatResult {
    case noAmmo        // No ammunition available
    case noTargets     // No valid targets in range
    case fired         // Attack fired, result pending
    case missed        // Attack missed the target
    case hit           // Attack hit the target
    case destroyed     // Target was destroyed
    case absorbed      // Energy absorbed (e.g. by a Star)
    case protected     // Attack blocked (e.g. by a Starbase)
}

/// The type of attack used during combat.
enum AttackType {
    case phasers
    case torpedo
}

/// Represents the outcome of a combat interaction.
struct CombatEvent {
    /// The attacking object.
    let attacker: any Locatable

    /// The type of attack used.
    let attackType: AttackType

    /// Energy expended during the attack.
    let attackEnergy: Int

    /// The target of the attack (if any).
    let target: (any Locatable)?

    /// Energy that reached the target.
    let impactEnergy: Int

    /// The result of the attack.
    let result: CombatResult
}
