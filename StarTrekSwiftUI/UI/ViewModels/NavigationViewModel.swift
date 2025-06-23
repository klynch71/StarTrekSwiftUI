//
//  NavigationViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//

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
    func engageWarpEngines() {
        
        let oldQuadrant = appState.enterprise.location.quadrant
        
        resolveNavigation()
        
        // If still in the same quadrant, trigger potential Klingon combat.
        let newQuadrant = appState.enterprise.location.quadrant //after resolving move
        if (oldQuadrant == newQuadrant) {
            resolveCombat()
        }
    }
    
    /// Evaluates and applies navigation logic, such as movement and boundary handling.
    private func resolveNavigation()  {
        let event = NavigationEvaluator(appState: appState).evaluateMove()
        NavigationEventResolver(appState: appState).resolve(event)
    }
    
    /// Resolves post-movement Klingon attacks, if applicable.
    /// - Returns: Formatted combat log messages.
    private func resolveCombat() {
        let combatEvents = CombatEvaluator(appState: appState).klingonsAttack()
        CombatResolver(appState: appState).resolve(combatEvents)
    }
}
