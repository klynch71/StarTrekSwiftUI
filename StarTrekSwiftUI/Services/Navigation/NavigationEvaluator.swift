//
//  NavigationEvaluator.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/17/25.
//

import Foundation

/// The `NavigationEvaluator` evaluates the result of the Enterprise's navigation move.
/// It **does not modify any state** but instead returns a `NavigationEvent` describing the outcome.
///
/// This evaluator calculates the path of movement based on the current course and warp factor.
/// It performs incremental checks for collisions, galaxy boundaries, and docking opportunities.
///
/// - Note: A sector is 1 unit wide and a WarpFactor of 0.1 corresponds to moving 1 sector.
struct NavigationEvaluator {
    
    /// Reference to the global application state.
    let appState: AppState
    
    /// Evaluates the Enterprise's move given its current course and speed (warp factor).
    ///
    /// The movement is simulated incrementally to check for collisions, galaxy boundaries, and starbase docking.
    /// The method calculates energy requirements and returns appropriate navigation events without mutating state.
    ///
    /// - Returns: A `NavigationEvent` representing the outcome of the move attempt.
    ///
    /// Possible outcomes include:
    /// - `.insufficientEnergy` if the Enterprise lacks sufficient energy for the move.
    /// - `.stoppedAtEdge` if the move attempts to go beyond galaxy boundaries.
    /// - `.stoppedByCollision` if the Enterprise collides with an object within the starting quadrant.
    /// - `.dockedAtStarbase` if the Enterprise docks at a starbase (either by collision or adjacency).
    /// - `.movedSuccessfully` if the move completes without incident.
    func evaluateMove() -> NavigationEvent {
        
        guard !appState.enterprise.damage.isDamaged(.engines) else {
            return .enginesDamaged
        }
  
        let entLoc = appState.enterprise.location
        let distance = appState.enterprise.warpFactor * 10
        
        //check for sufficient energy
        let requiredEnergy = Int(distance.rounded())
        if requiredEnergy > appState.enterprise.freeEnergy {
            return .insufficientEnergy(requiredEnergy: requiredEnergy, availableEnergy: appState.enterprise.freeEnergy)
        }
 
        let startLoc = entLoc
        var lastLoc = entLoc
        var x = Double(entLoc.x)
        var y = Double(entLoc.y)
        let interpolationSteps = 1000
        let course = appState.enterprise.navigationCourse
        let dx = distance * cos(course.radians) / Double(interpolationSteps)
        let dy = -distance * sin(course.radians) / Double(interpolationSteps) //y increase downward
        
        for _ in 0..<interpolationSteps {
            x += dx
            y += dy
            
            //make sure we don't leave the Galaxy
            if GalaxyLocation.inGalaxy(x: Int(x.rounded()), y: Int(y.rounded())) == false {
                return .stoppedAtEdge(startLocation: startLoc, finalLocation: lastLoc, energyCost: requiredEnergy)
            }
            
            let newLoc = GalaxyLocation(x: Int(x.rounded()), y: Int(y.rounded()))
            if newLoc != lastLoc {
                //check for collision in the starting quadrant
                let objects = appState.galaxyObjects.filter {$0.location == newLoc}
                if objects.first != nil && newLoc.quadrant == startLoc.quadrant {
                    if let Starbase = objects.first as? Starbase {
                        return .dockedAtStarbase(finalLocation: lastLoc, starbase: Starbase, energyCost: requiredEnergy)
                    }
                    return .stoppedByCollision(finalLocation: lastLoc, collidedObject: objects.first!, energyCost: requiredEnergy)
                }
                lastLoc = newLoc
            }
        }
        
        //we didn't hit anythihg. Did we dock?
        if let Starbase = appState.adjacentStarbases(to: lastLoc).first {
            return .dockedAtStarbase(finalLocation: lastLoc, starbase: Starbase, energyCost: requiredEnergy)
        }
        
        //successful move to lastLoc
        return .movedSuccessfully(startLocation: startLoc, finalLocation: lastLoc, energyCost: requiredEnergy)
    }
}
