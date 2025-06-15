//
//  CombatEngine.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/9/25.
//

import Foundation

/// Responsible for handling combat logic between the Enterprise and Klingon ships.
///
/// The `CombatEngine` produces `CombatEvent` results but does **not** directly mutate `AppState`.
/// Actual application state updates (e.g., damage application) are handled externally by a resolver.
struct CombatEngine {
    
    let appState: AppState
    
    /// Fires phasers at all Klingon ships in the current quadrant.
    ///
    /// - Parameter phaserEnergy: The total energy to use for phaser attacks.
    /// - Returns: An array of `CombatEvent` results, including Klingon counterattacks.
    func firePhasers(phaserEnergy: Int) -> [CombatEvent] {
        let phaserSystem = PhaserSystem(appState: appState)
        let events = phaserSystem.fire(phaserEnergy: phaserEnergy)
        return events + klingonsAttack(after: events)
    }
    
    /// Fires a single photon torpedo along a given course.
    ///
    /// - Parameter course: The direction/course to fire the torpedo.
    /// - Returns: An array of `CombatEvent` results, including Klingon counterattacks.
    func fireTorpedo(course: Course) -> [CombatEvent] {
        let torpedoSystem = TorpedoSystem(appState: appState)
        let events = torpedoSystem.fire(at: course)
        return events + klingonsAttack(after: events)
    }
    
    /// Causes all Klingons in the Enterprise's quadrant to attack.
    ///
    /// - Returns: An array of `CombatEvent` results representing Klingon attacks.
    func klingonsAttack() -> [CombatEvent] {
        return klingonsAttack(after: [])
    }
    
    /// Causes Klingon counterattacks after the Enterprise's initial attack.
    ///
    /// - Parameter events: A list of prior CombatEvent`s (e.g., phaser or torpedo fire).
    /// - Returns: An array of `CombatEvents representing Klingon retaliation.
    private func klingonsAttack(after events: [CombatEvent]) -> [CombatEvent] {
        // Filter out Klingons that were already destroyed in previous events
        let klingons = remainingKlingons(after: events)
        
        // Each surviving Klingon performs an attack
        return klingons.flatMap {
            KlingonWeaponSystem(appState: appState, klingon: $0).fire()
        }
    }
    
    /// Filters and returns all Klingons in the Enterprise's quadrant that are still alive.
    ///
    /// - Parameter events: A list of prior `CombatEvent`s (some may contain destroyed Klingons).
    /// - Returns: A list of surviving `Klingon` instances.
    private func remainingKlingons(after events: [CombatEvent]) -> [Klingon] {
        let allKlingons = appState.objects(ofType: Klingon.self,
                                           in: appState.enterprise.location.quadrant)
        
        // Extract Klingons that were destroyed in earlier combat events
        let destroyedKlingons = Set(
            events
                .filter { $0.result == .destroyed }
                .compactMap { $0.target as? Klingon }
        )

        // Return only those Klingons not previously destroyed
        let remainingKlingons = allKlingons.filter { !destroyedKlingons.contains($0) }
        return remainingKlingons
    }
}
