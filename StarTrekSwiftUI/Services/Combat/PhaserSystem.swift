//
//  PhaserSystem.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

///  A PhaserSystem is a WeaponSystem that fires phasers at all Klingons in the same Quadrant.
struct PhaserSystem: WeaponSystem {
    var appState: AppState
    var type: AttackType = .phasers
    
    /// Fires phasers at all Klingons in the current quadrant using the specified energy.
    ///
    /// - Parameter phaserEnergy: The amount of energy to be distributed across targets.
    /// - Returns: An array of `CombatEvent`s representing the firing result.
    func fire(phaserEnergy: Int) -> [UnresolvedCombatEvent] {
        
        // Check for damaged weapon
        guard !appState.enterprise.damage.isDamaged(.phaserControl) else {
            return weaponDamagedEvent(attacker: appState.enterprise, attackType: .phasers)
        }
        
        // Check for insufficient energy provided
        guard phaserEnergy > 0 else {
            return noAmmoEvent(attacker: appState.enterprise, attackType: .phasers)
        }
         
        // Check for no targets in range
        let klingons = klingonsInCurrentQuadrant()
        guard !klingons.isEmpty else {
            return noTargetsEvent(attackType: .phasers)
        }
        
        var events: [UnresolvedCombatEvent] = []
        
        // Log the firing action
        events.append(firedEvent(attacker: appState.enterprise, attackType: .phasers))
        
        // Divide energy evenly among targets
        let energyPerEnemy = phaserEnergy / klingons.count
        
        //fire on each Klingon
        for klingon in klingons {
            let distance = appState.enterprise.location.distance(to: klingon.location)
            
            // Calculate damage with distance falloff and some randomness
            let impactEnergy = Int((Double(energyPerEnemy) / distance) * (2 + Double.random(in: 0..<1, using: &appState.rng)))
            let newEnergy = klingon.energy - impactEnergy
            
            // Determine hypothetical outcome based on current Klingon energy
            let effect: CombatEffect = newEnergy <= 0 ? .destroyed : .hit
            let event = UnresolvedCombatEvent(attacker: appState.enterprise, attackType: .phasers, attackEnergy: energyPerEnemy, target: klingon, impactEnergy: impactEnergy, effect: effect)
            events.append(event)
        }
        
        return events
    }
}
