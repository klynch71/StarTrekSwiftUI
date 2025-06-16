//
//  DamageControl.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// Handles damage management for ship systems.
struct DamageControl {
    let appState: AppState
    
    /// If no systems are damage, this function will attempt to induce random damage to a specified system, or
    /// a random system if none is provided.
    ///
    /// If one or more ssytems is currently damage, this function will attempt repairs.
    ///
    /// - Parameter system: An optional ship system to damage. If `nil`, a random system is chosen
    /// - Returns; a user friendly stinrg or nil if nothing happened.
    func handleDamageOrRepair(system: ShipSystem? = nil) -> String? {
        if appState.enterprise.condition == .docked {
            //if we have any damaged ssytems while docked, fix them.
            if !appState.enterprise.damage.isFullyOperational {
                appState.updateEnterprise {$0.damage.repairAll()}
                return "All systems have been fully repaired while docked."
            }
            return nil
        }
        
        if appState.enterprise.damage.isFullyOperational {
            return maybeInduceRandomDamage(system: system)
        }
        return repairDamage()
    }
        
    /// Attempts to induce random damage to a specified system, or a random system if none is provided.
    ///
    /// There is approximately a 1 in 7 (about 14%) chance of damage being induced.
    ///
    /// - Parameter system: An optional ship system to damage. If `nil`, a random system is chosen.
    /// - Returns: The damaged `ShipSystem` if damage occurred, otherwise `nil`.
    private func maybeInduceRandomDamage(system: ShipSystem? = nil) -> String? {
        // 1 in 7 chance to induce damage; 6 in 7 chance to skip
        if Int.random(in: 0..<7) > 0 {
            return nil
        }
        
        // Choose the system to damage: provided or random
        guard let actualSystem = system ?? ShipSystem.allCases.randomElement() else {
            return nil
        }
        
        // Induce damage between 1 and 5 points on the selected system
        let damage = 1 + Int.random(in: 0..<5)
        appState.updateEnterprise {$0.damage[actualSystem] += damage}
        
        return actualSystem.displayName + " has been damaged."
    }
    
    /// Attempts to repair one damaged system by decreasing its damage by 1.
    ///
    /// Repairs only one system at a time, prioritizing the first damaged system in the damage list.
    ///
    /// - Returns: The fully  repaired `system message` if repair completed this cycle, otherwise `nil`.
    private func repairDamage() -> String? {
        guard let system = appState.enterprise.damage.damagedSystems.first else {
            return nil
        }
        
        // Decrease damage on the system by 1
        appState.updateEnterprise {$0.damage[system] -= 1}
        
        // Return the system message only if it is now fully repaired
        return appState.enterprise.damage.isDamaged(system) ? nil : system.displayName + " has been repaired."
    }
}
