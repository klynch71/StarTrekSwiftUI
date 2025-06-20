//
//  GalaxyLocation.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/2/25.
//

import Foundation


 /// A location within the Galaxy.  All coordinates in a GalaxyLocation are 1-based.
 /// A GalaxyLocation can use three coordinate Systems:
 ///   1) A flat (x,y) where the Galaxy is laid out in a giant grid.
 ///   2) A location where the Galaxy is laid out in terms of Quadrants (X,Y) that contain Sectors (X,Y).  Sector(X,Y) is relative to the Quadrant.
 ///   3) A layout similar to 2) above, but Sectors are not relative to their Quadrant and have their own unique id.
struct GalaxyLocation: Hashable, Equatable {
    /// The global (x,y) coordinates in the Galaxy.
    let x: Int
    let y: Int
    
    /// /// 1-based quadrant and sector columns and rows
    var qX: Int {return getQuadrantColumn()}
    var qY: Int {return getQuadrantRow()}
    var sX: Int {return getSectorColumn()}
    var sY: Int {return getSectorRow()}
    
    /// Quadrant that this location resides in.
    var quadrant: Quadrant {return getQuadrant()}
    
    /// Absolute sector that this location resides in.
    var sector: Sector {return getSector()}
    
    /// Sector relative to its quadrant.
    var relativeSector: Sector {return getRelativeSector()}
    
    /// Initializes with flat (x, y) coordinates.
    /// - Parameters:
    ///   - x: Global X-coordinate (1-based).
    ///   - y: Global Y-coordinate (1-based).
    init(x: Int, y: Int) {
        precondition(GalaxyLocation.inGalaxy(x: x, y: y))
        self.x = x
        self.y = y
    }
    
    /// Initializes with quadrant and sector-relative coordinates.
    /// - Parameters:
    ///   - qX: 1-based quadrant column.
    ///   - qY: 1-based quadrant row.
    ///   - sX: 1-based sector column within the quadrant.
    ///   - sY: 1-based sector row within the quadrant.
    init(qX: Int, qY: Int, sX: Int, sY: Int) {
        let globalX = (qX - 1) * Galaxy.sectorCols + sX
        let globalY = (qY - 1) * Galaxy.sectorRows + sY
        self.init(x: globalX, y: globalY)
    }
    
    /// Initializes from an absolute sector ID.
    /// - Parameter sector: Absolute sector with a unique global ID.
    init(sector: Sector) {
        //determine which quadrant the sector is in
        let sectorsPerQuadrant = Galaxy.quadrantCols * Galaxy.sectorRows
        let quadrantIndex = sector.id / sectorsPerQuadrant
        
        // Sector offset within the Quadrant
        let sectorOffset = sector.id % sectorsPerQuadrant
        let localX = sectorOffset % Galaxy.sectorCols
        let localY = sectorOffset / Galaxy.sectorCols
        
        // Determine the Quadrant's position in the 8x8 grid
        let quadrantX = quadrantIndex % Galaxy.quadrantCols
        let quadrantY = quadrantIndex / Galaxy.quadrantCols
        
        // Global coordinates are offset by quadrant's position
        let globalX = quadrantX * Galaxy.sectorCols + localX + 1
        let globalY = quadrantY * Galaxy.sectorCols + localY + 1
        
        self.init(x: globalX, y: globalY)
    }
        
    /// Returns a random valid GalaxyLocation.
    /// - Returns: A location within the bounds of the Galaxy.
    static func random() -> GalaxyLocation {
        let maxX = Galaxy.quadrantCols * Galaxy.sectorCols
        let maxY = Galaxy.quadrantRows * Galaxy.sectorRows
        
        let x = Int.random(in:1...maxX)
        let y = Int.random(in:1...maxY)
  
        return GalaxyLocation(x: x, y: y)
    }
    
    /// Checks whether a given (x, y) is within Galaxy bounds.
    /// - Parameters:
    ///   - x: X-coordinate (1-based).
    ///   - y: Y-coordinate (1-based).
    /// - Returns: `true` if (x, y) is in bounds.
    static func inGalaxy(x: Int, y: Int) -> Bool {
        let maxX = Galaxy.quadrantCols * Galaxy.sectorCols
        let maxY = Galaxy.quadrantRows * Galaxy.sectorRows
        
        return (x > 0 && x <= maxX && y > 0 && y <= maxY)
    }
    
    /// Computes the Euclidean distance to another location.
    /// - Parameter other: The target location.
    /// - Returns: The distance as a Double.
    func distance(to other: GalaxyLocation) -> Double {
        let dx = other.x - self.x
        let dy = other.y - self.y
        
        let distanceSquared = Double(dx*dx + dy*dy)
        return distanceSquared.squareRoot( )
    }
    
    /// Computes the directional course to another location.
    /// - Parameter other: The target location.
    /// - Returns: A `Course` representing the angle from this location.
    func course(to other: GalaxyLocation) -> Course {
        let dx = Double(other.x - self.x)
        let dy = Double(self.y - other.y) //y increases downward
        
        let radians = atan2(dy, dx)
        return Course(radians: radians)
    }
    
    /// Produces navigation data to reach another location.
    /// - Parameter other: The target location.
    /// - Returns: `NavigationData` containing course and distance.
    func navigate(to other: GalaxyLocation) -> NavigationData {
        let course = course(to: other)
        let distance = distance(to: other)
        return NavigationData(course: course, distance: distance)
    }
    
    // MARK: - private
    
    /// Returns the 1-based quadrant column.
    private func getQuadrantColumn() -> Int {
        return Int(x - 1) / Galaxy.sectorCols + 1
    }
    
    /// Returns the 1-based quadrant row.
    private func getQuadrantRow() -> Int {
        return Int(y - 1) / Galaxy.sectorRows + 1
    }

    /// Returns the 1-based sector column relative to the quadrant.
    private func getSectorColumn() -> Int {
        return Int(x - 1) % Galaxy.sectorCols + 1
    }
    
    /// Returns the 1-based sector row relative to the quadrant.
    private func getSectorRow() -> Int {
        return Int(y - 1) % Galaxy.sectorRows + 1
    }
    
    /// Returns the `Quadrant` this location is part of.
    private func getQuadrant() -> Quadrant {
        let col = Int(x - 1) / Galaxy.sectorCols
        let row = Int(y - 1) / Galaxy.sectorRows
        let quadrantNumber = col + row * Galaxy.quadrantCols
        
        return Quadrant(quadrantNumber)
    }
    
    /// Returns the relative `Sector` within this location's quadrant.
    private func getRelativeSector() -> Sector {
        let col = getSectorColumn()
        let row = getSectorRow()
        let index = col - 1 + (row - 1) * Galaxy.sectorCols  //zero-based
        return Sector(index)
    }
    
    /// Returns the absolute `Sector` this location corresponds to.
    private func getSector() -> Sector {
        let numSectorsInQuadrant = Galaxy.sectorCols * Galaxy.sectorRows
        let sectorNum = self.relativeSector.id + numSectorsInQuadrant * self.quadrant.id

        return Sector(sectorNum)
    }
}
