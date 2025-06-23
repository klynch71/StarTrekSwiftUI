//
//  DamageControl.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

/// Handles damage management for ship systems, including inducing random damage
/// and performing repairs. All changes are published as `DamageEvent`s.
struct DamageControl {
    let appState: AppState
    
    /// Either induces random damage or performs a repair, depending on the ship's state.
    ///
    /// - If the ship is fully operational, this attempts to induce random damage
    ///   to the specified system (or a random one).
    /// - If any systems are damaged, this attempts to repair one system.
    ///
    /// - Parameter system: The specific system to damage. If `nil`, a random system is chosen.
    func handleDamageOrRepair(system: ShipSystem? = nil) {
        if appState.enterprise.damage.isFullyOperational {
            maybeInduceRandomDamage(system: system)
        } else {
            repairDamage()
        }
    }
    
    /// Fully repairs all ship systems and publishes a `.allRepaired` event.
    func repairAll() {
        appState.updateEnterprise {$0.damage.repairAll()}
        
        // Notify observers that all systems were repaired at once
        GameEventBus.shared.damagePublisher.send(.allRepaired)
    }
    
    /// Attempts to induce random damage to a specific or random system.
    ///
    /// There is a ~14% chance (1 in 7) of damage being induced.
    /// Damage is randomly chosen between 1 and 5 points.
    ///
    /// - Parameter system: The system to damage, or `nil` to choose randomly.
    private func maybeInduceRandomDamage(system: ShipSystem? = nil) {
            
        // 1 in 7 chance to induce damage; 6 in 7 chance to skip
        if Int.random(in: 0..<7) > 0 {
            return
        }
        
        // Choose the system to damage: provided or random
        guard let actualSystem = system ?? ShipSystem.allCases.randomElement() else {
            return
        }
        
        // Induce damage between 1 and 5 points on the selected system
        let oldDamage = appState.enterprise.damage[actualSystem]
        let additionalDamage = 1 + Int.random(in: 0..<5)

        // Apply the damage
        appState.updateEnterprise {
            $0.damage[actualSystem] += additionalDamage
        }

        let newDamage = appState.enterprise.damage[actualSystem]

        // Create and publish the damage event
        let systemDamageEvent = ShipSystemDamageEvent(
            system: actualSystem,
            oldDamage: oldDamage,
            newDamage: newDamage
        )
        GameEventBus.shared.damagePublisher.send(.system(systemDamageEvent))
    }
    
    /// Repairs a single damaged system by reducing its damage by 1 point.
    ///
    /// Only one system is repaired at a time. The first damaged system found is prioritized.
    /// Publishes a `.system(...)` event for the repair.
    private func repairDamage() {
        guard let system = appState.enterprise.damage.damagedSystems.first else {
            return
        }
        
        // Decrease damage on the system by 1
        let oldDamage = appState.enterprise.damage[system]
        appState.updateEnterprise {$0.damage[system] -= 1}
        let newDamage = appState.enterprise.damage[system]
        
        // Create the damage event
        let systemDamageEvent = ShipSystemDamageEvent(
            system: system,
            oldDamage: oldDamage,
            newDamage: newDamage
        )

        // Publish the event
        let event = DamageEvent.system(systemDamageEvent)
        GameEventBus.shared.damagePublisher.send(event)
    }
}
