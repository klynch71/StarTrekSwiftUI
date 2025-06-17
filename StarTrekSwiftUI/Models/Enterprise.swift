//
//  Enterprise.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/12/25.
//

import Foundation
import Combine

/// The condition of the USS Enterprise.
enum ShipCondition: String, CaseIterable, Identifiable {
    case green      // Fully operational
    case docked     // Docked at a starbase
    case caution    // Caution due to low energy or minor damage
    case alert      // Red alert: immediate threat or heavy damage

    var id: Self { self }
}

/// Sensor system status.
enum SensorStatus {
    case shortRangeOn
    case longRangeOn
    case allOff
}

/// The USS Enterprise NCC-1701.
struct Enterprise: Observable, Locatable {
    
    // MARK: - Constants
    
    static let maxWarp = 8.0
    static let torpedoCapacity: Int = 10
    static let maxEnergy: Int = 3000
    
    // MARK: - Identity & Location
    
    /// Unique ID for this ship instance.
    let id: UUID
    
    /// Current location in the galaxy.
    var location: GalaxyLocation
    
    // MARK: - Status
    
    var condition: ShipCondition = .green
    var sensorStatus: SensorStatus = .allOff
    var damage = ShipSystemDamage() //track system damage
    var exploredSpace = Set<Quadrant>()  //quadrants that have been explored
    
    // MARK: - Energy & Weapons
    
    /// Total energy including shields and weapons.
    var totalEnergy:Int  = Enterprise.maxEnergy
    
    /// Energy not allocated to shields or phasers.
    var freeEnergy: Int { max(0, totalEnergy - shieldEnergy - phaserEnergy) }
    
    var shieldEnergy:Int = 0
    var phaserEnergy: Int = 0
    
    /// Number of photon torpedoes.
    var torpedoes: Int = Enterprise.torpedoCapacity
    
    // MARK: - Navigation
    
    /// Warp factor (0.0 to maxWarp).
    var warpFactor: Double = 0.1 {
        didSet {
            let clamped = min(max(0, warpFactor), Enterprise.maxWarp)
            if clamped != warpFactor {      // prevent infinite recursion on @Published var
                warpFactor = clamped
            }
        }
    }
    var navigationCourse: Course = Course(degrees: 0)
    var torpedoCourse: Course = Course(degrees: 0)
    
    // MARK: - Locatable
    
    /// Display name of the ship.
    var name: String { "Enterprise" }
    
    /// Creates a new Enterprise at the given location.
    /// - Parameter location: Starting position in the galaxy.
    init(id: UUID, location: GalaxyLocation) {
        self.id = id
        self.location = location
    }

    // MARK: - Equatable
    
    static func == (lhs: Enterprise, rhs: Enterprise) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func refit() {
        
    }
}
