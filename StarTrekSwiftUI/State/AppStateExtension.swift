//
//  AppStateExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

/// Extension on AppState providing helper functions for querying and manipulating galaxy objects.
extension AppState {
    
    // MARK: - Object Queries
        
    /// Returns all galaxy objects of the specified type.
    /// - Parameter type: The type to filter for.
    func objects<T: Locatable>(ofType type: T.Type) -> [T] {
        return galaxyObjects.compactMap { $0 as? T }
    }
    
    /// Returns all galaxy objects of the specified type located in the given quadrant.
    /// - Parameters:
    ///   - type: The type to filter for.
    ///   - quadrant: The quadrant to search within.
    func objects<T: Locatable>(ofType type: T.Type, in quadrant: Quadrant) -> [T] {
        let objects = objects(in: quadrant)
        return objects.compactMap { $0 as? T }
    }
    
    /// Returns all galaxy objects  in the given quadrant.
    /// - Parameters:
    ///   - quadrant: The quadrant to search within.
    func objects(in quadrant: Quadrant) -> [any Locatable] {
        return galaxyObjects.filter {$0.location.quadrant == quadrant}
    }
    
    /// Returns the first object located in the given sector, or `nil` if none exists.
    /// - Parameter sector: The sector to check.
    func object(in sector: Sector) -> (any Locatable)? {
        let objects = galaxyObjects.filter {$0.location.sector == sector}
        return objects.first
    }
    
    // MARK: - Spatial Relationships

    /// Returns all Starbases in sectors adjacent to the given location.
    /// - Parameter location: The reference location.
    func adjacentStarbases(to location: GalaxyLocation) -> [Starbase] {
        //offsets to get adjance sectors
        let offsets = [
            (-1, -1), (0, -1), (1, -1),
            (-1,  0),          (1,  0),
            (-1,  1), (0,  1), (1,  1)]
        var adjacentSectors = Array<Sector?>()
        
        for (dx, dy) in offsets {
            let x = location.x + dx
            let y = location.y + dy
            if GalaxyLocation.inGalaxy(x: x, y: y) {
                let newLocation = GalaxyLocation(x: x, y: y)
                adjacentSectors.append(newLocation.sector)
            }
        }
        
        let adjacentObjects = galaxyObjects.filter {adjacentSectors.contains($0.location.sector)}
        return adjacentObjects.compactMap { $0 as? Starbase }
    }
    
    /// Returns the 3x3 grid of quadrants surrounding the Enterprise's current quadrant.
    ///
    /// Quadrants outside of the galaxy bounds are returned as `nil`.
    /// The array is ordered as:
    /// `top-left, top-center, top-right, center-left, center, center-right, bottom-left,
    ///  bottom-center, bottom-right.
    func adjacentQuadrants() -> Array<Quadrant?> {
        let offsets = [
            (-1, -1), (0, -1), (1, -1),
            (-1, 0),  (0,  0), (1, 0),
            (-1, 1),  (0, 1),  (1, 1)];
        var quadrants = Array<Quadrant?>()
        let quadrant = enterprise.location.quadrant
  
        // Determine the zero-based row,col of the quadrant we are in
        let col = quadrant.id % Galaxy.quadrantCols
        let row = quadrant.id / Galaxy.quadrantCols

        // Helper to get quadrant at a grid position or nil
        func quadrantAt(row: Int, col: Int) -> Quadrant? {
            guard row >= 0, row < Galaxy.quadrantRows,
                  col >= 0, col < Galaxy.quadrantCols else {
                return nil
            }
            let id = row * Galaxy.quadrantCols + col
            return Quadrant(id)
        }
        for (dx, dy) in offsets {
            let quadrant = quadrantAt(row: row + dy, col: col + dx)
            quadrants.append(quadrant)
        }
        return quadrants
    }
    
    // MARK: - Object Management and Mutation

    /// Randomizes the sector positions of all objects in the given quadrant.
    ///
    /// Ensures that no objects are placed where the Enterprise currently resides.
    /// - Parameter quadrant: The quadrant to randomize objects in.
    func randomizeObjects(in quadrant: Quadrant) {

        let entLocation = enterprise.location
        var sectors = entLocation.quadrant.sectors.filter { $0 != entLocation.sector }

        // Loop with index so we can mutate directly since we are storing structs
        for i in galaxyObjects.indices {
            if galaxyObjects[i].location.quadrant == quadrant {
                guard let randomSector = sectors.randomElement() else { continue }
                sectors.removeAll { $0 == randomSector }
                let newLocation = GalaxyLocation(sector: randomSector)
                galaxyObjects[i] = galaxyObjects[i].withLocation(newLocation)
            }
        }
    }
    
    /// Replace one Locatable with another.  The new object should have the same id as the object it
    /// is replacing.
    /// - Parameter newObject: The object to replace the existing object with the same id.
    func replaceLocatable(with newObject: some Locatable) {
        if let index = galaxyObjects.firstIndex(where: { $0.id == newObject.id }) {
            var copy = galaxyObjects
            copy[index] = newObject
            galaxyObjects = copy // This triggers the view update
        } else {
            print("⚠️ No locatable found with id \(newObject.id)")
        }
    }
}
