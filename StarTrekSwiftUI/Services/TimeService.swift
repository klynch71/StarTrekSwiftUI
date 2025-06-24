//
//  TimeService.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// A service responsible for advancing in-game time based on navigation events.
struct TimeService {
    let appState: AppState
    
    /// Advances the starDate based on warp speed and whether a quadrant boundary was crossed.
    ///
    /// - Parameters:
    ///   - warp: The warp factor at which the ship is traveling.
    ///   - crossedQuadrant: Whether the ship crossed into a new quadrant during movement.
    func advance(forWarp warp: Double, crossedQuadrant: Bool) {
        // For warp speeds less than 1.0, time advances in finer granularity (0.1 increments).
        if warp < 1.0 {
            let delta = 0.1 * Double(Int(warp * 10))
            appState.starDate += delta
        } else {
            // For warp 1.0 and above, time advances by 1 stardate unit.
            appState.starDate += 1.0
        }

        // Additional time penalty for crossing into a new quadrant.
        if crossedQuadrant {
            appState.starDate += 1.0
        }
        
        //The game is over when the current starDate exceeds the endData
        if appState.starDate >= appState.endDate {
            appState.gameStatus = .lostOutOfTime
        }
    }
    
    /// Advances the stardate by 1.0 if the Enterprise is currently docked at a starbase.
    ///
    /// In the original 1978 Super Star Trek game, time advances by 1 unit on every command
    /// executed while docked. This includes commands that normally don't advance time (like scanning).
    /// This function should be called after each player action to preserve that behavior.
    func advanceIfDocked() {
        if appState.enterprise.condition == .docked {
            appState.starDate += 1.0
        }
    }
    
}
