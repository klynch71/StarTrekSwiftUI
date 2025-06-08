//
//  GameSetup.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/14/25.
//

import Foundation

/*
 Game Setup contains rules on setting up the game.  If you were to offer difficulty settings, you would handle them here.
 */
struct GameSetup {
    
    static let KLINGON_BASE_ENERGY = 200;
    
    /*
     reset the game.
     */
    static func reset(_ model: AppState) {
        model.galaxyObjects.removeAll()
        model.log.removeAll()
        model.gameOver = false
        
        //set the stardate randomly between 2000 and 3900 in increments of 100
        model.starDate = Int.random(in: 0...19)*100 + 2000 
        
        //put the enterprise in a random location within the Galaxy
        let randomLocation = Location(sector: Sector.random())
        model.enterprise = Enterprise(location: randomLocation)
        
        //put a random number of Klingons, stars, and starbases in each Quadrant
        for quadrant in Galaxy.quadrants {
            //don't put an object where the enterprise is located
            var sectors = quadrant.sectors.filter{$0 != randomLocation.sector};
            
            //place Klingons randomly in quadrant
            let numEnemies = numEnemiesInQuadrant();
            for _ in (0..<numEnemies) {
                let enemeySector = sectors.randomElement()!;
                sectors.removeAll {$0 == enemeySector};
                //klingon enery varies from 1/2 BASE to 1.5 BASE
                let energy = klingonEnergy()
                let enemyLocation = Location(sector: enemeySector)
                let klingon = Klingon(location: enemyLocation, energy: energy)
                model.galaxyObjects.append(klingon)
            }
            
            //place stars randomly in quadrant
            let numStars = numStarsInQuadrant();
            for _ in (0..<numStars) {
                let starSector = sectors.randomElement()!
                sectors.removeAll {$0 == starSector}
                let starLocation = Location(sector: starSector)
                model.galaxyObjects.append(Star(location: starLocation))
            }
            
            //place starbases in quadrent
            let numStarBases = numStarBasesInQuadrant();
            for _ in (0..<numStarBases) {
                let starBaseSector = sectors.randomElement()!
                sectors.removeAll {$0 == starBaseSector}
                let starBaseLocation = Location(sector: starBaseSector)
                model.galaxyObjects.append(StarBase(location: starBaseLocation))
            }
        }
        
        //we need at least one StarBase in the Galaxy
        let starBases = model.galaxyObjects.filter {$0 is StarBase}
        if starBases.isEmpty {
            //pur a StarBase in a random location the Galaxy
            let randomQuandrant = Galaxy.quadrants.randomElement()!
            var sectors = randomQuandrant.sectors;
            let objectSectors = model.galaxyObjects.map {$0.location.sector!}
            sectors.removeAll {objectSectors.contains($0)}
            let starBaseSector = sectors.randomElement()!
            let starBaseLocation = Location(sector: starBaseSector)
            let starBase = StarBase(location: starBaseLocation)
            model.galaxyObjects.append(starBase)
        }
    }
    
    /*
     returns a random number of enemies from 0 to 3.
     The original game has the odds as follows:
     odds > 0.98 = 3 enemies
     odds > 0.95 = 2 enemies
     odds > 0.80 = 1 enemy
     odds <= 0.80 = 0 enemies
     */
    private static func numEnemiesInQuadrant() -> Int {
        let odds = Double.random(in: 0...1.0);
        if odds > 0.98 {
            return 3;
        } else if odds > 0.95 {
            return 2;
        } else if odds > 0.80 {
            return 1;
        } else {
            return 0;
        }
    }
    
    /*
     returns a random number of stars from 1 to 8.
     */
    private static func numStarsInQuadrant() -> Int {
        return Int.random(in: 1...8);
    }
    
    /*
     return a random number of starBases in a Quadrant.
     if the odds > 0.96 then there's a starBase in this Quadrant.
     */
    private static func numStarBasesInQuadrant() -> Int {
        let odds = Double.random(in: 0...1.0);
        return (odds > 0.96) ? 1: 0;
    }
    
    /*
     return Klingon energy
     klingon enery varies from 1/2 x KLINGON_BASE_ENERGY to 1.5 x KLINGON_BASE_ENERGY
     */
    private static func klingonEnergy() -> Int {
        let energy: Int = Int(Double(KLINGON_BASE_ENERGY) * (0.5 + Double.random(in: 0...1)));
        return energy;
    }
}
