//
//  NavigationEvent.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Represents the result of an attempted navigation or movement action by the Enterprise.
///
/// Each case captures a specific outcome, along with any relevant data such as the final location or energy cost.
enum NavigationEvent {
    
    ///  Warp engines are damaged
    case enginesDamaged
    
    /// Movement failed due to insufficient energy.
    /// - Parameters:
    ///   - requiredEnergy: The energy that would have been needed to complete the move.
    ///   - availableEnergy: The energy currently available to the Enterprise.
    case insufficientEnergy(requiredEnergy: Int, availableEnergy: Int)
    
    /// Movement stopped at the edge of the galaxy — the Enterprise attempted to move beyond galaxy bounds.
    /// - Parameters:
    ///   - starLocation: The location where the Entrprise started from
    ///   - finalLocation: The furthest valid location the Enterprise reached.
    ///   - energyCost: The energy used to reach the edge.
    case stoppedAtEdge(startLocation: GalaxyLocation, finalLocation: GalaxyLocation, energyCost: Int)
    
    /// Movement stopped due to a collision with another object.
    /// - Parameters:
    ///   - finalLocation: The location where the Enterprise encountered the collision.
    ///   - collidedObject: The object that blocked the Enterprise (e.g., a star, Klingon, or starbase).
    ///   - energyCost: The energy used before the collision occurred.
    case stoppedByCollision(finalLocation: GalaxyLocation, collidedObject: any Locatable, energyCost: Int)
    
    /// Movement was successful and completed without docking.
    /// - Parameters:
    ///   - finalLocation: The final destination reached.
    ///   - energyCost: The total energy expended during the move.
    case movedSuccessfully(startLocation: GalaxyLocation, finalLocation: GalaxyLocation, energyCost: Int)
    
    /// Movement was successful and resulted in docking at a starbase.
    /// - Parameters:
    ///   - finalLocation: The location of the starbase docked with.
    ///   - Starbase: The starbase object that was docked with.
    ///   - energyCost: The energy used to reach the starbase.
    case dockedAtStarbase(finalLocation: GalaxyLocation, starbase: Starbase, energyCost: Int)
}
