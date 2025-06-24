//
//  GameStatusChecker.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Responsible for evaluating and updating the current game status
/// based on win/loss conditions like energy, time, Klingons, and starbases.
struct GameStatusChecker {
    let appState: AppState

    /// Checks the current game state and updates `appState.gameStatus` accordingly.
    ///
    /// Win and loss conditions are evaluated in priority order:
    /// - All Klingons destroyed → win
    /// - Energy depleted → loss
    /// - Time expired → loss
    /// - All starbases destroyed → loss
    /// - Otherwise → game in progress
    func check() {
        // Win condition: no Klingons left
        let klingons = appState.objects(ofType: Klingon.self)
        if klingons.isEmpty {
            appState.gameStatus = .wonAllKlingonsDestroyed
            return
        }

        // Loss condition: no energy
        if appState.enterprise.totalEnergy <= 0 {
            appState.gameStatus = .lostEnterpriseDestroyed
            return
        }

        // Loss condition: time ran out
        if appState.starDate > appState.endDate {
            appState.gameStatus = .lostOutOfTime
            return
        }

        // Loss condition: no starbases
        let starBases = appState.objects(ofType: Starbase.self)
        if starBases.isEmpty {
            appState.gameStatus = .lostAllStarbasesDestroyed
            return
        }

        // Default: still playing
        appState.gameStatus = .inProgress
    }
}
