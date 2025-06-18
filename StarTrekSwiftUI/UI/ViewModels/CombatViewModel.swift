//
//  CombatViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/5/25.
//

import Foundation


/// The CombatViewModel is responsible for coordinating combat actions
/// including phaser attacks and photon torpedo launches. It delegates evaluation,
/// resolution, and formatting of combat outcomes.
struct CombatViewModel {
    let appState: AppState
    let combatEvaluator: CombatEvaluator
    let combatResolver: CombatResolver
    let combatFormatter: CombatEventFormatter
    
    /// Initializes the combat system with dependencies tied to the current game state.
    init(appState: AppState) {
        self.appState = appState
        self.combatEvaluator = CombatEvaluator(appState: appState)
        self.combatResolver = CombatResolver(appState: appState)
        self.combatFormatter = CombatEventFormatter()
    }
    
    /// Fires phasers at all enemy ships in the current quadrant.
    ///
    /// Phaser energy is distributed across all enemies.
    /// Any surviving enemies may retaliate as part of the resolved combat events.
    ///
    /// - Parameter phaserEnergy: The total energy allocated to the phaser attack.
    /// - Returns: An array of log messages describing the results of the attack and retaliation.
    func firePhasers(phaserEnergy: Int) -> [String] {
        let combatEvents = combatEvaluator.firePhasers(phaserEnergy: phaserEnergy)
        let resolvedEvents = combatResolver.resolve(combatEvents)
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
    
    /// Fires a photon torpedo along a specified course.
    ///
    /// The torpedo travels until it hits an object or misses entirely.
    /// The outcome (hit, miss, destruction, retaliation) is evaluated and formatted.
    ///
    /// - Parameter course: The directional course to fire the torpedo.
    /// - Returns: An array of log messages describing the torpedo's effect.
    func fireTorpedo(at course: Course) -> [String] {
        let combatEvents = combatEvaluator.fireTorpedo(course: course)
        let resolvedEvents = combatResolver.resolve(combatEvents)
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
}
