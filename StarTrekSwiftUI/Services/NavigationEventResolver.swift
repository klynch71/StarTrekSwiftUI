//
//  NavigationEventResolver.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

import Foundation

/// A NavigationEventResolver takes an array of NavigationEvents and makes the appropriate changes to AppSstate
struct NavigationEventResolver {
    let appState: AppState
    let formatter: NavigationEventFormatter
    
    init(appState: AppState) {
        self.appState = appState
        self.formatter = NavigationEventFormatter()
    }

    /// Resolves a single navigation event and returns messages suitable for display.
    ///
    /// - Parameter event: The `NavigationEvent` to resolve.
    /// - Returns: An array of display strings describing the result of the navigation event.
    func resolve(_ event: NavigationEvent) -> [String] {
        updateAppState(for: event)
        
        if let message = formatter.message(for: event) {
            return [message]
        }
        return []
    }
    
    /// Updates the AppState based on the NavigationEvent's effects.
    ///
    /// - Parameter event: The `NavigationEvent` whose outcome should be applied to the AppState.
    private func updateAppState(for event: NavigationEvent) {
        let previousLocation = appState.enterprise.location
        var updatedLocation = previousLocation
        var energyCost = 0
        let targetWarp = appState.enterprise.warpFactor
        
        switch event {
        case .enginesDamaged, .insufficientEnergy(_, _):
            return  //No movement or energy
            
        case .movedSuccessfully(let newLocation, let energy):
            updatedLocation = newLocation
            energyCost = energy
            
        case .stoppedAtEdge(let edge, let energy),
             .stoppedByCollision(let edge, _, let energy),
            .dockedAtStarbase(let edge, _, let energy):
                    updatedLocation = edge
                    energyCost = energy
                    appState.updateEnterprise {$0.warpFactor = 0}
                }
        
        //move the enterprise and update energy expenditure
        appState.updateEnterprise {$0.location = updatedLocation}
        let newEnergy = max(0, appState.enterprise.totalEnergy - energyCost)
        appState.updateEnterprise {$0.totalEnergy = newEnergy}
        
        // If moved to a new quadrant, randomize its contents
        let crossedQuadrant = updatedLocation.quadrant != previousLocation.quadrant
        if crossedQuadrant {
            appState.randomizeObjects(in: updatedLocation.quadrant)
            AppNotificationCenter.shared.postQuadrantDataDidChange()
        }
        
        // Advance time
        let timeService = TimeService(appState: appState)
        timeService.advance(forWarp: targetWarp, crossedQuadrant: crossedQuadrant)
    }
}
