//
//  AppState.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//

import Foundation
import Combine

/// A model representing the overall state of the game.
/// It holds key game entities and data such as the Enterprise, galaxy objects, log, stardate,
/// remaining time, and win/loss conditions.
final class AppState: ObservableObject {
    
    // MARK: - Game World State

    /// All locatable objects currently in the galaxy (e.g., Klingons, stars, starbases).
    @Published var galaxyObjects: [any Locatable] = []
    
    /// The player's ship, initialized at a random location in the galaxy.
    @Published private(set) var enterprise = Enterprise(id: UUID(), location: GalaxyLocation.random())
    
    // MARK: - Game Progress and Status

    /// The current stardate, incremented as the game progresses.
    @Published var starDate: Double = 0
    
    /// The stardate on which the mission should be completed.
    var endDate: Double = 0
    
    /// The remaining stardates before the game ends (if objectives aren't met).
    var timeRemaining: Double {
        max(0, endDate - starDate)
    }
    
    /// A flag indicating whether the game has ended, either by winning or losing.
    @Published var gameStatus: GameStatus = .inProgress

    // MARK: - UI and Feedback
    
    /// Log of notable game events for display to the player.
    @Published var log: [String] = []
    
    // MARK: - Initialization

    /// Initializes the game state and sets up the galaxy and initial conditions.
    init() {
        self.resetGame()
    }
    
    // MARK: - Game Lifecycle

    /// Resets the game state to its initial conditions using GameSetup.
    func resetGame() {
        GameSetup.reset(self)
    }
    
    /// Update a particular value for the enterprise.
    /// Usage: updateEnterprise { $0.totalEnergy = newEnergy}
    ///  Parameter - and enclosure updating an enterprise parameter
    func updateEnterprise(_ transform: (inout Enterprise) -> Void) {
        var newEnterprise = enterprise
        transform(&newEnterprise)
        enterprise = newEnterprise
    }
}

