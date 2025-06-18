//
//  NavigationViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//
import Foundation

/*
 moves the Enterprise via warp engines
 */
struct NavigationViewModel {
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    /*
     set Enterprise course and speed
     */
    func setCourseAndSpeed(navData: NavigationData) {
        //computer must be oeprational for auto navigation and targeting
        guard !appState.enterprise.damage.isDamaged(.computer) else {
            appState.log.append("Computer damaged.  Auto navigation and targeting are unavailable.")
            return
        }
        
        appState.updateEnterprise {$0.navigationCourse = navData.course}
        
        //set speed based on distance.  The NavData distance is in sectors
        // and we can move 1 sector in 0.1 warpFactor.
        var speed = navData.distance * 0.1
        speed = min(speed, Enterprise.maxWarp)
        speed = max(0, speed)
        appState.updateEnterprise {$0.warpFactor = speed}
        
        //set torpedo course to aim where we are headed
        appState.updateEnterprise {$0.torpedoCourse = navData.course}
    }
    
    /*
     Move the enterprise given it's current course and speed.
     A Sector is 1 unit wide and WarpFactor 0.1 = 1 Sector.
     Return an array of log messages which might be empty.
     */
    func engageWarpEngines() -> [String] {
        
        let oldQuadrant = appState.enterprise.location.quadrant
        
        let navigationMessages = resolveNavigation()
        
        //if we didn't move out of the quadrant there is a possibility of a Klingon attack
        let newQuadrant = appState.enterprise.location.quadrant //after resolving move
        let combatMessages = (oldQuadrant == newQuadrant) ? resolveCombat() : []
        
        return navigationMessages + combatMessages
    }
    
    /*
     a helper function to resolve Navigation
     */
    private func resolveNavigation() -> [String] {
        let event = NavigationEvaluator(appState: appState).evaluateMove()
        return  NavigationEventResolver(appState: appState).resolve(event)
    }
    
    /*
     a helper functon to resolve Klingons attacking after moving in the same quadrant
     */
    private func resolveCombat() -> [String] {
        let combatEvents = CombatEvaluator(appState: appState).klingonsAttack()
        let resolvedEvents = CombatResolver(appState: appState).resolve(combatEvents)
        let combatFormatter = CombatEventFormatter()
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
}
