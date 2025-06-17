//
//  ShipSystem.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//

/// Represents a system on the ship that can be damaged or repaired.
enum ShipSystem: CaseIterable, Equatable {
    /// Controls ship movement.
    case engines
    
    /// Provides visual info about objects in the current Quadrant.
    case shortRangeScanner
    
    /// Proivides visual info about objects in adjacent Sectors..
    case longRangeScanner
    
    /// Manages energy shields.
    case shieldControl
    
    /// Controls photon torpedo system.
    case torpedoControl
    
    /// Central computer for navigation and operations.
    case computer
    
    /// Phaser weapon control system.
    case phaserControl
}

/// an extension to provide user friendly names for each system
extension ShipSystem {
    /// A user-friendly name for each system.
    var displayName: String {
        switch self {
        case .engines: return "Warp Engines"
        case .shortRangeScanner: return "Short Range Scanner"
        case .longRangeScanner: return "Long Range Scanner"
        case .shieldControl: return "Shield Control"
        case .torpedoControl: return "Photon Torpedo System"
        case .computer: return "Computer"
        case .phaserControl: return "Phaser Control"
        }
    }
}
