//
//  GameStatus.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//

import Foundation

/// Represents the current status of the game.
enum GameStatus: Equatable {
    case inProgress
    case wonAllKlingonsDestroyed
    case lostEnterpriseDestroyed
    case lostAllStarbasesDestroyed
    case lostOutOfTime
    
    /// Whether the game is over (won or lost).
    var isGameOver: Bool {
        switch self {
        case .inProgress:
            return false
        default:
            return true
        }
    }
}
