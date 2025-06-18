//
//  UnresolvedCombatEvent.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/7/25.
//

/// Represents the outcome of a combat interaction.
struct UnresolvedCombatEvent {
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
    let effect: CombatEffect
}
