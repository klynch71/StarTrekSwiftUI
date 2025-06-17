//
//  CombatViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/5/25.
//

import Foundation


/// The CombatViewModel handles firing Phasers and Photon Torpedoes.
struct CombatViewModel {
    let appState: AppState
    let combatEvaluator: CombatEvaluator
    let combatResolver: CombatResolver
    let combatFormatter: CombatEventFormatter
    
    init(appState: AppState) {
        self.appState = appState
        self.combatEvaluator = CombatEvaluator(appState: appState)
        self.combatResolver = CombatResolver(appState: appState)
        self.combatFormatter = CombatEventFormatter()
    }
    
    /*
     fire phasers at all enemies in the quadrant. Enemies that survive will fire back.
     Rreturn an array of resulting log messages
     */
    func firePhasers(phaserEnergy: Int) -> [String] {
        let combatEvents = combatEvaluator.firePhasers(phaserEnergy: phaserEnergy)
        let resolvedEvents = combatResolver.resolve(combatEvents)
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
    
    /*
     fire a photon torpedo and handle the results
     */
    func fireTorpedo(at course: Course) -> [String] {
        let combatEvents = combatEvaluator.fireTorpedo(course: course)
        let resolvedEvents = combatResolver.resolve(combatEvents)
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
}
