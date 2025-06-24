//
//  Galaxy.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/11/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/**
 A Galaxy consists of 16 named StarSystems.
 Each StarSystem has four Quadrants, designated with the suffix " I", " II", " III", or " IV".
 Thus, the Galaxy contains a total of 64 Quadrants.

 Each Quadrant contains 64 Sectors arranged in an 8×8 grid.
 A Sector is the smallest unit of space and may contain a star, Starbase, ship, or be empty.

 Therefore, the Galaxy contains 64 × 64 = 4,096 Sectors in total.
 Sector locations are laid out linearly:
 
 Sectors 0–63 correspond to the first Quadrant (e.g., "Antares I"),
 Sectors 64–127 to the second Quadrant (e.g., "Antares II"), and so on.
 */

struct Galaxy {
    
    ///The names of the starSystems in the Galaxy.
    static let starSystemNames = ["Antares","Rigel","Procyon","Vega","Canopus","Altair","Sagittarius","Pollux",
                                  "Sirius","Deneb","Capella","Betelgeuse","Aldebaran","Regulus","Arcturus","Spica"]
    
    ///The prefixes used for the quadrants in each starSystem
    static let quadrantSuffixes = [" I"," II"," III"," IV"]
    
    ///The dimensions for Quadrants and Sectors in the Galaxy.
    static let quadrantCols = 8
    static let quadrantRows = 8
    static let sectorCols = 8
    static let sectorRows = 8
    
    ///All quadrants in the Galaxy
    static let quadrants = Array(0..<(Galaxy.quadrantCols * Galaxy.quadrantRows)).map { Quadrant($0) }
}

