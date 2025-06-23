//
//  ShipSystemDamage.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//

/// Tracks the damage levels of the ship's key systems.
struct ShipSystemDamage: Equatable, Hashable {
    
    /// Damage level for the engines (0 means undamaged).
   var engines: Int = 0
   
    /// Damage level for the short-range scanner.
   var shortRangeScanner: Int = 0
   
    /// Damage level for the long-range scanner.
   var longRangeScanner: Int = 0
   
    /// Damage level for the shield control system.
   var shieldControl: Int = 0
   
    /// Damage level for the photon torpedo system.
   var torpedoControl: Int = 0
   
    /// Damage level for the computer.
   var computer: Int = 0
   
    /// Damage level for the phasers.
   var phaserControl: Int = 0
   
    /// Returns `true` if all ship systems are fully operational (i.e., have zero damage)
   var isFullyOperational: Bool {
       return ShipSystem.allCases.allSatisfy { self[$0] == 0 }
   }
   
    /// Returns a list of ship systems that are currently damaged (i.e., have damage > 0).
   var damagedSystems: [ShipSystem] {
       ShipSystem.allCases.filter { self[$0] > 0 }
   }
   
    /// Checks if the specified system is damaged.
    /// - Parameter system: The system to check.
    /// - Returns: `true` if the system's damage is greater than 0.
   func isDamaged(_ system: ShipSystem) -> Bool {
       self[system] > 0
   }
    
/// Repairs all systems by setting their damage levels to 0.
    mutating func repairAll() {
        for keyPath in Self.systemKeyPaths.values {
            self[keyPath: keyPath] = 0
        }
    }

}

// MARK: - Subscript Access to System Damage Values

/// Enables array-like access to system damage values using `SystemDamage[.phasers]`, etc.
extension ShipSystemDamage {
    
   /// Maps each `ShipSystem` to its corresponding writable key path in the struct.
   private static let systemKeyPaths: [ShipSystem: WritableKeyPath<ShipSystemDamage, Int>] = [
       .engines: \.engines,
       .shortRangeScanner: \.shortRangeScanner,
       .longRangeScanner: \.longRangeScanner,
       .shieldControl: \.shieldControl,
       .torpedoControl: \.torpedoControl,
       .computer: \.computer,
       .phaserControl: \.phaserControl
   ]
   
    /// Allows getting or setting a specific system's damage value using subscript syntax.
    /// - Parameter system: The ship system to access.
   subscript(system: ShipSystem) -> Int {
       get { self[keyPath: Self.systemKeyPaths[system]!] }
       set { self[keyPath: Self.systemKeyPaths[system]!] = newValue }
   }
}
