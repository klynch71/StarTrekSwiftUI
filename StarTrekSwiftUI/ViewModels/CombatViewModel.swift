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
    let combatEngine: CombatEngine
    let combatResolver: CombatEventResolver
    
    init(appState: AppState) {
        self.appState = appState
        self.combatEngine = CombatEngine(appState: appState)
        self.combatResolver = CombatEventResolver(appState: appState)
    }
    
    /*
     fire phasers at all enemies in the quadrant. Enemies that survive will fire back.
     Rreturn an array of resulting log messages
     */
    func firePhasers(phaserEnergy: Int) -> [String] {
        let combatEvents = combatEngine.firePhasers(phaserEnergy: phaserEnergy)
        return combatResolver.resolve(combatEvents)
    }
    
    /*
     fire a photon torpedo and handle the results
     */
    func fireTorpedo(at course: Course) -> [String] {
        let combatEvents = combatEngine.fireTorpedo(course: course)
        return combatResolver.resolve(combatEvents)
    }
}
