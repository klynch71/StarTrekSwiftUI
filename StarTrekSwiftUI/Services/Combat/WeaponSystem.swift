//
//  WeaponSystem.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

///A Protocol for implementing weapon systems
protocol WeaponSystem {
    var appState: AppState { get }
    var type: AttackType { get }
}

/// Common helper methods shared by all weapon systems.
extension WeaponSystem {
    
    /// Returns all Klingons currently in the same quadrant as the Enterprise.
    ///
    /// - Returns: An array of `Klingon` objects located in the same quadrant.
    func klingonsInCurrentQuadrant() -> [Klingon] {
        appState.objects(ofType: Klingon.self,
                         in: appState.enterprise.location.quadrant)
    }
    
    /// Returns a `.noTargets` combat event with the Enterprise as the attacker.
    ///
    /// - Parameter attackType: The type of attack that failed due to no targets.
    /// - Returns: An array containing a single `.noTargets` `UnresolvedCombatEvent`.
    func noTargetsEvent(attackType: AttackType) -> [UnresolvedCombatEvent] {
        return [
            UnresolvedCombatEvent(
                attacker: appState.enterprise,
                attackType: attackType,
                attackEnergy: 0,
                target: nil,
                impactEnergy: 0,
                effect: .noTargets
            )
        ]
    }
    
    /// Returns a `.fired` combat event for a given attacker and weapon type.
    ///
    /// - Parameters:
    ///   - attacker: The entity that initiated the attack.
    ///   - attackType: The type of weapon used in the attack.
    /// - Returns: A `CombatEvent` representing the firing action.
    func firedEvent(attacker: any Locatable, attackType: AttackType) -> UnresolvedCombatEvent {
        return UnresolvedCombatEvent(
            attacker: attacker,
            attackType: attackType,
            attackEnergy: 0,
            target: nil,
            impactEnergy: 0,
            effect: .fired
        )
    }
    
    /// Returns a `.noAmmo` combat event for a given attacker and weapon type.
    ///
    /// - Parameters:
    ///   - attacker: The entity attempting to fire a weapon without ammunition.
    ///   - attackType: The type of weapon that lacked ammunition.
    /// - Returns: An array containing a single `.noAmmo` `CombatEvent`.
    func noAmmoEvent(attacker: any Locatable, attackType: AttackType) -> [UnresolvedCombatEvent] {
        return [UnresolvedCombatEvent(
            attacker: attacker,
            attackType: attackType,
            attackEnergy: 0,
            target: nil,
            impactEnergy: 0,
            effect: .noAmmo
        )
        ]
    }
    
    /// Returns a `.weaponDamaged` combat event for a given attacker and weapon type.
    ///
    /// - Parameters:
    ///   - attacker: The entity that initiated the attack.
    ///   - attackType: The type of weapon used in the attack.
    /// - Returns: A `CombatEvent` representing the firing action.
    func weaponDamagedEvent(attacker: any Locatable, attackType: AttackType) -> [UnresolvedCombatEvent] {
        return [UnresolvedCombatEvent(
            attacker: attacker,
            attackType: attackType,
            attackEnergy: 0,
            target: nil,
            impactEnergy: 0,
            effect: (attackType == .torpedo)
                ? .systemDamaged(.torpedoControl)
                : .systemDamaged(.phaserControl)
            )
        ]
    }
}


