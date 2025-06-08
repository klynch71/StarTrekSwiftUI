//
//  Galaxy.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/11/25.
//

import Foundation

/*
 A Galaxy consists of 16 named StarSystems.
 Each StarSystem has four Quadrants that are designated with the suffix "I", "II",
 "III" or "IV".  Thus we have a totaly of 64 Quadrants in a Galaxy.
 Each Quadrant contains 64 Sectors.
 A Sector is the smallest unit of space and contain a single star, starbase, ship, or empty space.
 Thus, a Galaxy consits of 64*64 = 4,096 Sectors. A Sector Location determines a precise location within the Galaxy.
 
 The Galaxy is laid out in linear fashion.
 Sector Locations 0-63 are for the first Quadrant (ie; Antares I), 64-127 for the second Quadrant (ie; Antares II), etc.
 */

struct Galaxy {
    
    static let STAR_SYSTEM_NAMES = ["Antares","Rigel","Procyon","Vega","Canopus","Altair","Sagittarius","Pollux",
                                       "Sirius","Deneb","Capella","Betelgeuse","Aldebaran","Regulus","Arcturus","Spica"]
    static let QUADRANT_SUFFIXES = [" I"," II"," III"," IV"]
    static let NUM_QUADRANTS = STAR_SYSTEM_NAMES.count * QUADRANT_SUFFIXES.count;
    static let quadrants = Array(0..<NUM_QUADRANTS).map { Quadrant($0) };
    
    /*
     returns an array of sectors that are adjacent to and include the given location.
     The order of the array is:
     top-left, top-center, top-right,left, right, bottom-left, bottom-right
     The return array will contain nil for Sectors that are outside our Galaxy
     */
    static func adjacentSectors(to location: Location) -> Array<Sector?> {
        let offsets = [
            (-1, -1), (0, -1), (1, -1),
            (-1, 0),  (0,  0), (1, 0),
            (-1, 1),  (0, 1),  (1, 1)];
        var sectors = Array<Sector?>();
        
        for (dx, dy) in offsets {
            let x = location.x + Double(dx);
            let y = location.y + Double(dy);
            let newLocation = Location(x: x, y: y)
            sectors.append(newLocation.sector)
        }
        return sectors;
    }
    
    /*
     return an array of quadrants that are adjacent to and include the given location.
     A quadrant is nil if it is outside the galaxy.
     */
    static func adjacentQuadrants(to location: Location) -> Array<Quadrant?> {
        let offsets = [
            (-1, -1), (0, -1), (1, -1),
            (-1, 0),  (0,  0), (1, 0),
            (-1, 1),  (0, 1),  (1, 1)];
        var quadrants = Array<Quadrant?>()
        
        if location.quadrant == nil {
            return quadrants
        }
        
        // Determine which quadrant the location is in
        let col = (Int(location.x) - 1) / Location.QUADRANT_COLS
        let row = (Int(location.y) - 1) / Location.QUADRANT_ROWS

        // Helper to get quadrant at a grid position or nil
        func quadrantAt(row: Int, col: Int) -> Quadrant? {
            guard row >= 0, row < Location.QUADRANT_ROWS,
                  col >= 0, col < Location.QUADRANT_COLS else {
                return nil
            }
            let id = row * Location.QUADRANT_COLS + col
            return Quadrant(id)
        }
        for (dx, dy) in offsets {
            let quadrant = quadrantAt(row: row + dy, col: col + dx)
            quadrants.append(quadrant)
        }
        return quadrants;
        
    }
}

