//
//  GameSetup.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/14/25.
//

import Foundation

/// Handles game setup rules and initialization.
/// If difficulty settings are added, this struct would manage them.
struct GameSetup {
    
    /// Resets the game state for a new game.
    ///
    /// This method clears all galaxy objects and logs, resets game over flag,
    /// randomly initializes the star date and time remaining,
    /// places the Enterprise at a random location,
    /// populates the galaxy with Klingons, Stars, and Starbases,
    /// ensures at least one Starbase exists,
    /// and initializes the ship condition and game log with starting information.
    ///
    /// - Parameter appState: The current game state to be reset.
    static func reset(_ appState: AppState) {
        appState.galaxyObjects.removeAll()
        appState.gameStatus = .inProgress
        var rng: any RandomNumberGenerator = SystemRandomNumberGenerator()
        
        // Set the stardate randomly between 2000 and 3900 in increments of 100
        appState.starDate = Double(Int.random(in: 0...19, using: &rng)*100 + 2000)
        
        // Set the game duration between 40 and 50 starDates
        let gameDuration = 40 + Int.random(in: 0...10, using: &rng)
        appState.endDate = appState.starDate + Double(gameDuration)
        
        // Place the enterprise in a random location within the Galaxy
        let randomLocation = GalaxyLocation.random()
        appState.updateEnterprise {$0.location = randomLocation}
        
        //refit and repair all damage
        ShipStatusService(appState: appState).refit()
        DamageControl(appState: appState).repairAll()
        
        // Populate each quadrant with galaxy objects excluding Enterprise's sector
        for quadrant in Galaxy.quadrants {
               // Prepare sectors: all but where Enterprise starts
               var availableSectors = quadrant.sectors.filter { $0 != appState.enterprise.location.sector }

               placeKlingons(in: quadrant, excluding: &availableSectors, into: &appState.galaxyObjects, rng: &rng)
               placeStars(in: quadrant, excluding: &availableSectors, into: &appState.galaxyObjects, rng: &rng)
               placeStarbases(in: quadrant, excluding: &availableSectors, into: &appState.galaxyObjects, rng: &rng)
           }
        
        // Ensure at least one Starbase exists in the galaxy
        ensureAtLeastOneStarbase(in: appState, using: &rng)
        
        // Initialize the ship conditions
        let shipStatusService = ShipStatusService(appState: appState)
        shipStatusService.setShipConditions()
        
        // Initialize the game log with starting instructions
        let endDate = appState.starDate + appState.timeRemaining
        let numKlingons = appState.objects(ofType: Klingon.self).count
        let numStarbases = appState.objects(ofType: Starbase.self).count
        let intro = GameIntroFormatter.missionBriefing(
            starDateEnd: endDate,
            timeRemaining: appState.timeRemaining,
            klingons: numKlingons,
            starbases: numStarbases
        )
        appState.log.removeAll()
        appState.log.append(intro)
    }
    
    /// Returns a random number of Klingon enemies (0 to 3) for a quadrant based on predefined odds.
    ///
    /// - Parameter rng: A random number generator.
    /// - Returns: Number of Klingons to place in the quadrant.
    private static func numEnemiesInQuadrant(rng: inout RandomNumberGenerator) -> Int {
        let odds = Double.random(in: 0...1.0, using: &rng)
        if odds > 0.98 {
            return 3
        } else if odds > 0.95 {
            return 2
        } else if odds > 0.80 {
            return 1
        } else {
            return 0
        }
    }
    
    /// Returns a random number of stars (1 to 8) to place in a quadrant.
    ///
    /// - Parameter rng: A random number generator.
    /// - Returns: Number of stars to place in the quadrant.
    private static func numStarsInQuadrant(rng: inout RandomNumberGenerator) -> Int {
        return Int.random(in: 1...8, using: &rng)
    }
    
    /// Determines if a Starbase should be placed in a quadrant.
    ///
    /// - Parameter rng: A random number generator.
    /// - Returns: Number of Starbases (0 or 1) to place in the quadrant.
    private static func numStarbasesInQuadrant(rng: inout RandomNumberGenerator) -> Int {
        let odds = Double.random(in: 0...1, using: &rng)
        return (odds > 0.96) ? 1: 0
    }
    
    /// Randomly places Klingons in the given quadrant.
    ///
    /// - Parameters:
    ///   - quadrant: The quadrant to place Klingons in.
    ///   - sectorsInUse: The sectors available for placement (sectors used will be removed).
    ///   - objects: The array of galaxy objects to append Klingons to.
    ///   - rng: A random number generator.
    private static func placeKlingons(in quadrant: Quadrant,
                                      excluding sectorsInUse: inout [Sector],
                                      into objects: inout [any Locatable],
                                      rng: inout RandomNumberGenerator)
    {
        let desired = numEnemiesInQuadrant(rng: &rng)
        var placed = 0
        
        while placed < desired,
              let sector = sectorsInUse.randomElement(using: &rng)
        {
            sectorsInUse.removeAll { $0 == sector }
            
            //klingon enery varies from 1/2 x baseEnergy to 1.5 x baseEnergy
            let factor = 0.5 + Double.random(in: 0...1, using: &rng)
            let energy = Int(Double(Klingon.baseEnergy) * factor)
            
            let loc = GalaxyLocation(sector: sector)
            objects.append(Klingon(id: UUID(), location: loc, energy: energy))
            placed += 1
        }
    }
    
    /// Randomly places Stars in the given quadrant.
    ///
    /// - Parameters:
    ///   - quadrant: The quadrant to place stars in.
    ///   - sectorsInUse: The sectors available for placement (sectors used will be removed).
    ///   - objects: The array of galaxy objects to append stars to.
    ///   - rng: A random number generator.
    private static func placeStars(in quadrant: Quadrant,
                                      excluding sectorsInUse: inout [Sector],
                                      into objects: inout [any Locatable],
                                      rng: inout RandomNumberGenerator)
    {
        let desired = numStarsInQuadrant(rng: &rng)
        var placed = 0
        
        while placed < desired,
              let sector = sectorsInUse.randomElement(using: &rng)
        {
            sectorsInUse.removeAll { $0 == sector }

            let loc = GalaxyLocation(sector: sector)
            objects.append(Star(id: UUID(), location: loc))
            placed += 1
        }
    }
    
    /// Randomly places Starbases in the given quadrant.
    ///
    /// - Parameters:
    ///   - quadrant: The quadrant to place Starbases in.
    ///   - sectorsInUse: The sectors available for placement (sectors used will be removed).
    ///   - objects: The array of galaxy objects to append Starbases to.
    ///   - rng: A random number generator.
    private static func placeStarbases(in quadrant: Quadrant,
                                      excluding sectorsInUse: inout [Sector],
                                      into objects: inout [any Locatable],
                                      rng: inout RandomNumberGenerator)
    {
        let desired = numStarbasesInQuadrant(rng: &rng)
        var placed = 0
        
        while placed < desired,
              let sector = sectorsInUse.randomElement(using: &rng)
        {
            sectorsInUse.removeAll { $0 == sector }

            let loc = GalaxyLocation(sector: sector)
            objects.append(Starbase(id: UUID(), location: loc))
            placed += 1
        }
    }
    
    /// Ensures there is at least one Starbase somewhere in the galaxy.
    ///
    /// - Parameters:
    ///   - appState: The current game state.
    ///   - rng: A random number generator.
    private static func ensureAtLeastOneStarbase(in appState: AppState, using rng: inout RandomNumberGenerator) {
        let Starbases = appState.galaxyObjects.filter { $0 is Starbase }
        guard Starbases.isEmpty else { return }

        let randomQuadrant = Galaxy.quadrants.randomElement(using: &rng)!
        var sectors = randomQuadrant.sectors
        let objectSectors = appState.galaxyObjects.map { $0.location.sector }
        sectors.removeAll { objectSectors.contains($0) }

        if let sector = sectors.randomElement(using: &rng) {
            let loc = GalaxyLocation(sector: sector)
            appState.galaxyObjects.append(Starbase(id: UUID(), location: loc))
        }
    }
}
