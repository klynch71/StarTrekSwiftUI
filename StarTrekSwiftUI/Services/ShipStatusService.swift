//
//  ShipStatusService.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//

import Foundation

struct ShipStatusService {
    let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    /*
     Set the condition of the ship based on current circumstances
     */
    func setShipConditions() {
        //mark explored quadrants based on current sensor status:
        if appState.enterprise.sensorStatus == .shortRangeOn {
            let currentQuadrant = appState.enterprise.location.quadrant
            appState.updateEnterprise {$0.exploredSpace.insert(currentQuadrant) }
        } else if appState.enterprise.sensorStatus == .longRangeOn {
            let quadrants = appState.adjacentQuadrants().compactMap {$0}
            appState.updateEnterprise { $0.exploredSpace.formUnion(quadrants)}
        }
        
        //if docking location, then dock, lower shields, repair damage, and refit the Enterprise
        if appState.adjacentStarbases(to: appState.enterprise.location).count > 0 {
            appState.updateEnterprise {$0.condition = .docked}
            appState.updateEnterprise {$0.shieldEnergy = 0}
            appState.updateEnterprise {$0.damage.repairAll()}
            refit()
            return
        }
        
        //if we haven't explored the quadrant we are in, conditions are .green as far as we know
        if !appState.enterprise.exploredSpace.contains(appState.enterprise.location.quadrant){
            appState.updateEnterprise {$0.condition = .green}
            return
        }
        
        //Klingons in the quadrant?
        let ourQuadrant = appState.enterprise.location.quadrant
        let klingons = appState.objects(ofType: Klingon.self, in: ourQuadrant)
        if klingons.count > 0 {
            appState.updateEnterprise {$0.condition = .alert}
            return
        }
        
        //Low energy
        if appState.enterprise.totalEnergy < 200 {
            appState.updateEnterprise {$0.condition = .caution}
            return
        }
        
        appState.updateEnterprise {$0.condition = .green}
    }
    
    /*
     refit the enterprise
     */
    private func refit() {
        appState.updateEnterprise {$0.totalEnergy = Enterprise.maxEnergy}
        appState.updateEnterprise {$0.shieldEnergy = 0}
        appState.updateEnterprise {$0.torpedoes = Enterprise.torpedoCapacity}
    }
}
