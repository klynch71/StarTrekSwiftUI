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
    
    init(appState: AppState) {
        self.appState = appState
    }

    /// Handles a single navigation event by updating the app state accordingly
    /// and publishing the event to notify any interested subscribers.
    ///
    /// - Parameter event: The `NavigationEvent` instance to process and broadcast.
    func resolve(_ event: NavigationEvent) {
        updateAppState(for: event)
        
        GameEventBus.shared.navigationPublisher.send(event)
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
            
        case .movedSuccessfully(_, let newLocation, let energy):
            updatedLocation = newLocation
            energyCost = energy
            
        case .stoppedAtEdge(_, let edge, let energy),
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
        }
        
        // Advance time
        let timeService = TimeService(appState: appState)
        timeService.advance(forWarp: targetWarp, crossedQuadrant: crossedQuadrant)
    }
}
