//
//  Quadrant.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/13/25.
//

import Foundation

/*
 A Quadrant within the Galaxy.
 Each quadrant contains 64 sectors.
 Sectors within a Quadrant are numbered based on the Quadrant number.
 Quadrant 0 has sectors 0..63, Quadrant 1 has sectors 64...127, etc.
 */
struct Quadrant: ExpressibleByIntegerLiteral, Identifiable, Equatable, Hashable {
    static let SECTORS_PER_QUADRENT = Location.SECTOR_COLS * Location.SECTOR_ROWS 
    let id : Int
    var starName: String {return Galaxy.STAR_SYSTEM_NAMES[id / Galaxy.QUADRANT_SUFFIXES.count]}
    var name:String {return self.starName + " " + Galaxy.QUADRANT_SUFFIXES[id % Galaxy.QUADRANT_SUFFIXES.count];}
    var sectors: Array<Sector> {
        let firstSector = Quadrant.SECTORS_PER_QUADRENT * id;
        let lastSector = firstSector + Quadrant.SECTORS_PER_QUADRENT - 1;
        return Array(firstSector...lastSector).map {Sector($0)};
    }
    
    init(integerLiteral val: Int) {
        precondition(val >= 0);
        precondition(val < Galaxy.NUM_QUADRANTS);
         self.id = val
    }
    
    init(_ val: Int) {
        self.init(integerLiteral: val);
    }
}
