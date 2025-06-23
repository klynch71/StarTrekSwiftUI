//
//  CombatViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/5/25.
//


/// The CombatViewModel is responsible for coordinating combat actions
/// including phaser attacks and photon torpedo launches. It delegates evaluation,
/// resolution, and formatting of combat outcomes.
struct CombatViewModel {
    let appState: AppState
    let combatEvaluator: CombatEvaluator
    let combatResolver: CombatResolver
    
    /// Initializes the combat system with dependencies tied to the current game state.
    init(appState: AppState) {
        self.appState = appState
        self.combatEvaluator = CombatEvaluator(appState: appState)
        self.combatResolver = CombatResolver(appState: appState)
    }
    
    /// Fires phasers at all enemy ships in the current quadrant.
    ///
    /// Phaser energy is distributed across all enemies.
    /// Any surviving enemies may retaliate as part of the resolved combat events.
    ///
    /// - Parameter phaserEnergy: The total energy allocated to the phaser attack.
    func firePhasers(phaserEnergy: Int) {
        let combatEvents = combatEvaluator.firePhasers(phaserEnergy: phaserEnergy)
        combatResolver.resolve(combatEvents)
    }
    
    /// Fires a photon torpedo along a specified course.
    ///
    /// The torpedo travels until it hits an object or misses entirely.
    /// The outcome (hit, miss, destruction, retaliation) is evaluated and formatted.
    ///
    /// - Parameter course: The directional course to fire the torpedo.
    func fireTorpedo(at course: Course) {
        let combatEvents = combatEvaluator.fireTorpedo(course: course)
        combatResolver.resolve(combatEvents)
    }
}
