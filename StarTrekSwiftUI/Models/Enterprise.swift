//
//  Enterprise.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/12/25.
//

import Foundation

enum ShipCondition {
    case green
    case docked
    case caution
    case alert
}

struct Enterprise: Locatable {
    static let INITIAL_TORPEDOES: Int = 10
    static let INITIAL_ENERGY: Double = 3000
    var location: Location {
        didSet {
            //we should be in the Galaxy!
            if let quadrant = location.quadrant {
                exploredSpace.insert(quadrant)
            }
        }
    }
    var name: String {return "Enterprise"}
    var condition: ShipCondition = .green
    
    var freeEnergy: Double {return self.energy - self.shields}
    var energy:Double  = INITIAL_ENERGY
    var shields:Double = 0
    var torpedoes: Int = INITIAL_TORPEDOES
    var phaserDamage: Int = 0
    var engineDamage: Int = 0
    var exploredSpace = Set<Quadrant>()
    
    init(location: Location) {
        self.location = location
        //we should be in the Galaxy!
        if let quadrant = self.location.quadrant {
            exploredSpace.insert(quadrant)
        }
    }
}
