//
//  KlingonWeaponSystem.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// A WeaponSystem representing the phaser attack capabilities of a Klingon ship.
struct KlingonWeaponSystem: WeaponSystem {
    var appState: AppState
    var klingon: Klingon
    var type: AttackType = .phasers
    
    /// Fires the Klingon's phasers at the Enterprise and returns the resulting combat events.
    ///
    /// The impact energy is calculated based on the Klingon's current energy and distance to the Enterprise,
    /// with some randomness applied. The attack energy expended by the Klingon is also randomized slightly.
    ///
    /// - Returns: An array containing a single `CombatEvent` representing the result of the attack.
    func fire() -> [UnresolvedCombatEvent] {
        //energy delivered is based on distance and some randomness
        let distanceDilution = max(1.0, klingon.location.distance(to: appState.enterprise.location))
        let impactEnergy = Int((Double(klingon.energy) / distanceDilution) * (2 + Double.random(in: 0..<1)))
        
        //energy depletion for a klingon is divided by between 3 and 4
        let attackEnergy = max(0, Int(Double(klingon.energy) / (3 + Double.random(in: 0..<1))))
        
        //determine results
        var effect = CombatEffect.hit
        if appState.enterprise.condition == .docked {
            effect = .protected
        } else if appState.enterprise.shieldEnergy < impactEnergy {
            effect = .destroyed
        }
        
        let event = UnresolvedCombatEvent(attacker: klingon, attackType: .phasers, attackEnergy: attackEnergy, target: appState.enterprise, impactEnergy: impactEnergy, effect: effect)
        
        return [event]
    }
}
