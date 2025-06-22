//
//  CombatEventResolver.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// Resolves UnresolvedCombatEvents by updating the AppState accordingly.
struct CombatResolver {
    let appState: AppState
    
    /// Processes an array of UnresolvedCombatEvents by updating AppState and
    /// publishing the event to notify any interested subscribers.
    ///
    /// - Parameter events: Array of UnresolvedCombatEvents to resolve.
    func resolve(_ events: [UnresolvedCombatEvent]) {

        for event in events {
            let resolvedEvent = updateAppState(for: event)
            
            GameEventBus.shared.combatPublisher.send(resolvedEvent)
        }
    }
    
    /// Updates the game state according to a single UnresolvedCombatEvent.
    ///
    /// - Parameter combatEvent: The UnresolvedCombatEvent to process.
    private func updateAppState(for combatEvent: UnresolvedCombatEvent) -> CombatEvent {
        
        // Handle attack from a Klingon ship
        if let klingon = combatEvent.attacker as? Klingon {
            return resolveKlingonAttack(klingon: klingon, for: combatEvent)
            
        // Handle attack from the Enterprise
        } else if let enterprise = combatEvent.attacker as? Enterprise {
            return resolveEnterpriseAttack(enterprise: enterprise, for: combatEvent)
        }
        
        return CombatEvent(attacker: combatEvent.attacker, attackType: combatEvent.attackType, target: combatEvent.target, effect: combatEvent.effect)
    }
    
    /// Resolves the effects of a Klingon attack on the Enterprise.
    /// - Parameters:
    ///   - klingon: The attacking Klingon ship.
    ///   - combatEvent: The combat event representing the attack.
    /// - Returns: the resolution of the combat
    private func resolveKlingonAttack(klingon: Klingon, for combatEvent: UnresolvedCombatEvent) -> CombatEvent {
        // Deplete Klingon energy by the attack energy used
        let newEnergy = klingon.energy - combatEvent.attackEnergy
        let newKlingon = klingon.withEnergy(newEnergy)
        appState.replaceLocatable(with: newKlingon)
        
        switch combatEvent.effect {
        case .noTargets, .noAmmo, .systemDamaged(_), .fired, .protected, .missed, .absorbed:
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

        return CombatEvent(attacker: newKlingon, attackType: combatEvent.attackType, target: appState.enterprise, effect: combatEvent.effect)
    }
    
    /// Resolves the effects of an Enterprise attack on a target (typically Klingon).
    /// - Parameters:
    ///   - enterprise: The attacking Enterprise.
    ///   - combatEvent: The combat event representing the attack.
    /// - Returns: the resolution of the combat
    private func resolveEnterpriseAttack(enterprise: Enterprise, for combatEvent: UnresolvedCombatEvent) -> CombatEvent {
        
        // Deduct ammunition or energy based on attack type and outcome
        if combatEvent.attackType == .torpedo && combatEvent.effect != .fired {
            let torpedoCount = max(0, enterprise.torpedoes - 1)
            appState.updateEnterprise {$0.torpedoes = torpedoCount}
        } else if combatEvent.attackType == .phasers && combatEvent.effect != .fired {
            let newTotalEnergy = max(0, appState.enterprise.totalEnergy - combatEvent.attackEnergy)
            appState.updateEnterprise {$0.totalEnergy = newTotalEnergy}
            appState.updateEnterprise {$0.phaserEnergy = 0}
        }
        
        // Handle damage or destruction of targeted Klingon ship
        if let klingon = combatEvent.target as? Klingon {
            // Deplete Klingon energy by the attack energy used
            let newEnergy = klingon.energy - combatEvent.impactEnergy
            let newKlingon = klingon.withEnergy(newEnergy)
            
            if combatEvent.effect == .destroyed {
                appState.galaxyObjects.removeAll { $0.id == klingon.id }
            } else if combatEvent.effect == .hit {
                appState.replaceLocatable(with: newKlingon)
            }
            
            return CombatEvent(attacker: appState.enterprise, attackType: combatEvent.attackType, target: newKlingon, effect: combatEvent.effect)
        }
        
        return CombatEvent(attacker: appState.enterprise, attackType: combatEvent.attackType, target: nil, effect: combatEvent.effect)
    }
}
