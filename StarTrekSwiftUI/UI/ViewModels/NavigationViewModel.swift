//
//  NavigationViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//
import Foundation

/// Handles warp movement and navigation logic for the Enterprise.
struct NavigationViewModel {
    private let appState: AppState
    
    /// Initializes the view model with the given application state.
    /// - Parameter appState: The shared application state.
    init(appState: AppState) {
        self.appState = appState
    }
    
    /// Sets the Enterprise's navigation course, warp speed, and torpedo course.
    /// - Parameter navData: The navigation data, including course and distance.
    func setCourseAndSpeed(navData: NavigationData) {
        //computer must be oeprational for auto navigation and targeting
        guard !appState.enterprise.damage.isDamaged(.computer) else {
            appState.log.append("Computer damaged.  Auto navigation and targeting are unavailable.")
            return
        }
        
        appState.updateEnterprise {$0.navigationCourse = navData.course}
        
        // Set speed based on distance: 1 sector = 0.1 warp factor.
        var speed = navData.distance * 0.1
        speed = speed.clamped(to: 0...Enterprise.maxWarp)
        appState.updateEnterprise {$0.warpFactor = speed}
        
        // Align torpedo course with navigation heading.
        appState.updateEnterprise {$0.torpedoCourse = navData.course}
    }
    
    /// Moves the Enterprise using the current course and warp factor.
    /// May trigger combat if the Enterprise remains in the same quadrant.
    ///
    /// - Returns: An array of log messages resulting from the move and any ensuing combat.
    func engageWarpEngines() -> [String] {
        
        let oldQuadrant = appState.enterprise.location.quadrant
        
        let navigationMessages = resolveNavigation()
        
        // If still in the same quadrant, trigger potential Klingon combat.
        let newQuadrant = appState.enterprise.location.quadrant //after resolving move
        let combatMessages = (oldQuadrant == newQuadrant) ? resolveCombat() : []
        
        return navigationMessages + combatMessages
    }
    
    /// Evaluates and applies navigation logic, such as movement and boundary handling.
    /// - Returns: Log messages related to navigation events.
    private func resolveNavigation() -> [String] {
        let event = NavigationEvaluator(appState: appState).evaluateMove()
        return  NavigationEventResolver(appState: appState).resolve(event)
    }
    
    /// Resolves post-movement Klingon attacks, if applicable.
    /// - Returns: Formatted combat log messages.
    private func resolveCombat() -> [String] {
        let combatEvents = CombatEvaluator(appState: appState).klingonsAttack()
        let resolvedEvents = CombatResolver(appState: appState).resolve(combatEvents)
        let combatFormatter = CombatEventFormatter()
        return resolvedEvents.map { combatFormatter.message(for: $0) }
    }
}
