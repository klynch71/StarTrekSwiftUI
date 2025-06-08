//
//  Sector.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/13/25.
//

import Foundation

/*
 A sector is a location within the Galaxy
 */
struct Sector: ExpressibleByIntegerLiteral, Identifiable, Equatable, Hashable {
    let id: Int
    
    init(integerLiteral val: Int) {
        precondition(val >= 0);
        precondition(val < Galaxy.quadrants.count * Quadrant.SECTORS_PER_QUADRENT);
        self.id = val;
    }
    
    init(_ val: Int) {
        self.init(integerLiteral: val);
    }
    
    /*
     return a random Sector
     */
    static func random() -> Sector {
        let sectorID = Int.random(in: 0..<Galaxy.quadrants.count * Quadrant.SECTORS_PER_QUADRENT)
        return Sector(sectorID)
    }
}
