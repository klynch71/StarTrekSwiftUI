//
//  ShipStatusService.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//

import Foundation

/// A service responsible for determining and updating the ship's status,
/// including condition, repairs, docking, and refitting.
struct ShipStatusService {
    let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    /// Updates the ship's condition based on current location, sensor status, nearby threats, and energy.
    func setShipConditions() {
        updateExploredSpace()

        //if we haven't explored the quadrant we are in, conditions are .green as far as we know
        guard appState.enterprise.exploredSpace.contains(appState.enterprise.location.quadrant) else {
            appState.updateEnterprise { $0.condition = .green }
            return
        }
        
        if !appState.enterprise.isDocked && canDock() {
            dockAndRefit()
        } else if isThreatDetected() {
            appState.updateEnterprise { $0.condition = .alert }
        } else if isLowEnergy() {
            appState.updateEnterprise { $0.condition = .caution }
        } else {
            appState.updateEnterprise { $0.condition = .green }
        }
        
        updateSystemCapabilities()
    }
    
    /// Fully restores energy and munitions to the Enterprise
    func refit() {
        appState.updateEnterprise { enterprise in
            enterprise.totalEnergy = Enterprise.maxEnergy
            enterprise.shieldEnergy = 0
            enterprise.phaserEnergy = 0
            enterprise.torpedoes = Enterprise.torpedoCapacity
        }
    }
    
    /// Sets the ship's condition to docked, refills energy and resources, and repairs damage.
    private func dockAndRefit() {
        appState.updateEnterprise { $0.condition = .docked }
        DamageControl(appState: appState).repairAll()
        refit()
    }
    
    /// Marks the current or adjacent quadrants as explored based on the active sensor system.
    private func updateExploredSpace() {
        switch appState.enterprise.sensorStatus {
        case .shortRangeOn:
            let current = appState.enterprise.location.quadrant
            appState.updateEnterprise { $0.exploredSpace.insert(current) }

        case .longRangeOn:
            let quadrants = appState.adjacentQuadrants().compactMap { $0 }
            appState.updateEnterprise { $0.exploredSpace.formUnion(quadrants) }

        case .allOff:
            break
        }
    }
    
    /// Checks if a starbase is adjacent and the ship should dock.
    private func canDock() -> Bool {
        !appState.adjacentStarbases(to: appState.enterprise.location).isEmpty
    }
    
    /// Checks for the presence of Klingon ships in the current quadrant.
    private func isThreatDetected() -> Bool {
        let quadrant = appState.enterprise.location.quadrant
        return !appState.objects(ofType: Klingon.self, in: quadrant).isEmpty
    }
    
    /// Determines if the ship is in a low energy state.
    private func isLowEnergy() -> Bool {
        appState.enterprise.totalEnergy < Enterprise.lowEnergy
    }
    
    /// check for disabled systems
    private func updateSystemCapabilities() {
        appState.updateEnterprise { enterprise in
            if enterprise.damage.isDamaged(.engines) {
                enterprise.warpFactor = 0
            }
            if enterprise.damage.isDamaged(.phaserControl) {
                enterprise.phaserEnergy = 0
            }
        }
    }
}
