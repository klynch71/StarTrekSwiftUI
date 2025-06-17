//
//  NavigationEventFormatter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//

import Foundation

/// Converts a NavigationEvent into a user-friendly display string.
struct NavigationEventFormatter {
    let appState: AppState
    
    /// Returns a user-friendly UI message for the given navigation event.
    ///
    /// - Parameter event: The `NavigationEvent` to format.
    /// - Returns: A UI display string describing the event, or `nil` if no message is needed.
    func message(for event: NavigationEvent) -> String? {
        
        switch event {
        case .enginesDamaged:
            return "Engines are damaged.  Repairs are underway."
            
        case .movedSuccessfully(_, _):
            // No message needed for successful movement
            return nil
            
        case .insufficientEnergy(_, _):
            return "Insufficient energy to travel at that speed."
            
        case .stoppedAtEdge(_, _):
            return "The Enterprise must remain within Galaxy boundaries."
            
        case .stoppedByCollision(_, let object, _):
            return collisionMessage(for: object)
            
        case .dockedAtStarbase(_, let starbase, _):
            return "Enterprise docked to Starbase at sector: \(LocationFormatter.localSector(starbase.location))."
        }
    }
    
    /// Returns a collision message based on the collided object.
    /// - Parameter object: The `GalaxyObject` that was collided with.
    /// - Returns: A UI string describing the collision.
    private func collisionMessage(for object: any Locatable) -> String {
        let sector = LocationFormatter.localSector(object.location)

        switch object {
        case is Starbase:
            // Even though it's technically a collision, we treat it as docking
            return "Enterprise docked to Starbase at sector: \(sector)."
        case is Star:
            return "Getting too close to star at sector: \(sector). Warp engines shut down."
        case is Klingon:
            return "Force field prevents ramming Klingon in sector: \(sector). Warp engines shut down."
        default:
            return "Unknown collision at sector: \(sector)."
        }
    }
}
