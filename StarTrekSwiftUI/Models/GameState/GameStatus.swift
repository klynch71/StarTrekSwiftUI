//
//  GameStatus.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents the current status of the game, including whether it is ongoing,
/// won, or lost for various reasons.
enum GameStatus: Equatable {
    /// The game is just starting
    case starting
    
    /// The game is currently in progress.
    case inProgress
        
    /// The player has won by destroying all Klingons.
    case wonAllKlingonsDestroyed
        
    /// The game is lost because the Enterprise has been destroyed.
    case lostEnterpriseDestroyed
        
    /// The game is lost because all Starbases have been destroyed.
    case lostAllStarbasesDestroyed
        
    /// The game is lost because the player ran out of time.
    case lostOutOfTime
    
    /// Indicates whether the game has ended (either won or lost).
    var isGameOver: Bool {
        switch self {
        case .starting, .inProgress:
            return false
        default:
            return true
        }
    }
    
    /// A user-facing message describing the current game status.
    var message: String {
        switch self {
        case .starting:
            return "Ready to begin."
        case .inProgress:
            return "Game in progress."
        case .wonAllKlingonsDestroyed:
            return "Victory! All Klingons have been eliminated."
        case .lostEnterpriseDestroyed:
            return "Game Over. The Enterprise has been destroyed."
        case .lostAllStarbasesDestroyed:
            return "Game Over. All Starbases have been destroyed."
        case .lostOutOfTime:
            return "Game Over. You have run out of time."
        }
    }
}
