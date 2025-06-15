//
//  CombatEventResolver.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// Resolves CombatEvents by updating the AppState accordingly.
struct CombatEventResolver {
    let appState: AppState
    let formatter = CombatEventFormatter()
    
    /// Processes an array of CombatEvents by updating AppState and returning user-facing messages.
    ///
    /// - Parameter events: Array of CombatEvents to resolve.
    /// - Returns: Array of formatted messages describing the combat outcomes.
    func resolve(_ events: [CombatEvent]) -> [String] {
        var messages: [String] = []
        
        for event in events {
            updateAppState(for: event)
            messages.append(formatter.message(for: event))
        }
        
        ///if a command is run while docked, time advances
        TimeService(appState: appState).advanceIfDocked()
        
        return messages
    }
    
    /// Updates the game state according to a single CombatEvent.
    ///
    /// - Parameter combatEvent: The CombatEvent to process.
    private func updateAppState(for combatEvent: CombatEvent) {
        
        // Handle attack from a Klingon ship
        if let klingon = combatEvent.attacker as? Klingon {
            resolveKlingonAttack(klingon: klingon, for: combatEvent)
            
        // Handle attack from the Enterprise
        } else if let enterprise = combatEvent.attacker as? Enterprise {
            resolveEnterpriseAttack(enterprise: enterprise, for: combatEvent)
        }
    }
    
    /// Resolves the effects of a Klingon attack on the Enterprise.
    /// - Parameters:
    ///   - klingon: The attacking Klingon ship.
    ///   - combatEvent: The combat event representing the attack.
    private func resolveKlingonAttack(klingon: Klingon, for combatEvent: CombatEvent) {
        // Deplete Klingon energy by the attack energy used
        let newEnergy = klingon.energy - combatEvent.attackEnergy
        let newKlingon = klingon.withEnergy(newEnergy)
        appState.replaceLocatable(with: newKlingon)
        
        switch combatEvent.result {
        case .noTargets, .noAmmo, .fired, .protected, .missed, .absorbed:
            // No damage or effect on Enterprise
            break
            
        case .hit:
            // Reduce Enterprise shields and total energy by impact energy
            let shieldEnergy = max(0, appState.enterprise.shieldEnergy - combatEvent.impactEnergy)
            appState.updateEnterprise {$0.shieldEnergy = shieldEnergy}
            let totalEnergy = max(0, appState.enterprise.totalEnergy - combatEvent.impactEnergy)
            appState.updateEnterprise {$0.totalEnergy = totalEnergy}
            
        case .destroyed:
            // Enterprise destroyed, zero energy and end game
            appState.updateEnterprise {$0.shieldEnergy = 0}
            appState.updateEnterprise {$0.totalEnergy = 0}
            appState.gameStatus = .lostEnterpriseDestroyed
        }
    }
    
    /// Resolves the effects of an Enterprise attack on a target (typically Klingon).
    /// - Parameters:
    ///   - enterprise: The attacking Enterprise.
    ///   - combatEvent: The combat event representing the attack.
    private func resolveEnterpriseAttack(enterprise: Enterprise, for combatEvent: CombatEvent) {
        
        // Deduct ammunition or energy based on attack type and outcome
        if combatEvent.attackType == .torpedo && combatEvent.result != .fired {
            let torpedoCount = max(0, enterprise.torpedoes - 1)
            appState.updateEnterprise {$0.torpedoes = torpedoCount}
        } else if combatEvent.attackType == .phasers && combatEvent.result != .fired {
            let newTotalEnergy = max(0, appState.enterprise.totalEnergy - combatEvent.attackEnergy)
            appState.updateEnterprise {$0.totalEnergy = newTotalEnergy}
            appState.updateEnterprise {$0.phaserEnergy = 0}
        }
        
        // Handle damage or destruction of targeted Klingon ship
        if let klingon = combatEvent.target as? Klingon {
            if combatEvent.result == .destroyed {
                appState.galaxyObjects.removeAll { $0.id == klingon.id }
            } else if combatEvent.result == .hit {
                // Deplete Klingon energy by the attack energy used
                let newEnergy = klingon.energy - combatEvent.impactEnergy
                let newKlingon = klingon.withEnergy(newEnergy)
                appState.replaceLocatable(with: newKlingon)
            }
        }
    }
}
