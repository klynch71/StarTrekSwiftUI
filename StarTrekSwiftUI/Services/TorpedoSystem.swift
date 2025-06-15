//
//  TorpedoSystem.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// A `TorpedoSystem` is a `WeaponSystem` that fires a photon torpedo on a specified course.
struct TorpedoSystem: WeaponSystem {
    var appState: AppState
    var type: AttackType = .torpedo
    
    /// Fires a photon torpedo along the given course.
    ///
    /// This function simulates the firing of a photon torpedo from the Enterprise.
    /// It checks for ammunition, determines if there are targets in the quadrant,
    /// and calculates whether the torpedo hits an object or misses entirely.
    ///
    /// - Parameter course: The `Course` along which to fire the torpedo.
    /// - Returns: An array of `CombatEvent` objects representing the result of the attack,
    ///   including events for firing, hitting, missing, or absorbing by a star.
    func fire(at course: Course) -> [CombatEvent] {
        let enterprise = appState.enterprise

        // Check for available torpedoes
        guard enterprise.torpedoes > 0 else {
            return noAmmoEvent(attacker: enterprise, attackType: .torpedo)
        }

        // Check for enemies in the quadrant
        let klingons = klingonsInCurrentQuadrant()
        guard !klingons.isEmpty else {
            return noTargetsEvent(attackType: .torpedo)
        }

        var combatEvents: [CombatEvent] = []
        
        // Add firing event to indicate launch
        combatEvents.append(firedEvent(attacker: enterprise, attackType: .torpedo))

        var hitSomething = false
        var torpedoLocation = enterprise.location
        let quadrant = torpedoLocation.quadrant
        var lastSector = torpedoLocation.sector
        var x = Double(torpedoLocation.x)
        var y = Double(torpedoLocation.y)
        
        // Torpedo movement configuration
        let increment = 0.1
        let dx = increment * cos(course.radians)
        let dy = increment * sin(course.radians) // note: Y increases downward

        // Simulate torpedo path until it leaves the quadrant or galaxy
        while torpedoLocation.quadrant == quadrant &&
              GalaxyLocation.inGalaxy(x: Int(x.rounded()), y: Int(y.rounded())) {

            // Advance torpedo coordinates
            x += dx
            y -= dy

            let newX = Int(x.rounded())
            let newY = Int(y.rounded())

            // Update location if still in galaxy
            if GalaxyLocation.inGalaxy(x: newX, y: newY) {
                torpedoLocation = GalaxyLocation(x: newX, y: newY)

                if torpedoLocation.sector != lastSector {
                    // Check for a hit at new sector
                    if let hitObject = appState.object(in: torpedoLocation.sector) {
                        let result: CombatResult = (hitObject is Star) ? .absorbed : .destroyed
                        let event = CombatEvent(
                            attacker: enterprise,
                            attackType: .torpedo,
                            attackEnergy: 0,
                            target: hitObject,
                            impactEnergy: 1,
                            result: result
                        )
                        combatEvents.append(event)
                        hitSomething = true
                        break
                    }
                    lastSector = torpedoLocation.sector
                }
            } else {
                break // left the galaxy
            }
        }

        // If nothing was hit, report a miss
        if !hitSomething {
            let miss = CombatEvent(
                attacker: enterprise,
                attackType: .torpedo,
                attackEnergy: 0,
                target: nil,
                impactEnergy: 0,
                result: .missed
            )
            combatEvents.append(miss)
        }

        return combatEvents
    }
}
