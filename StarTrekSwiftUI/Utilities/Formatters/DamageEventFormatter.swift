//
//  DamageEventFormatter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/22/25.
//

/// Formats `DamageEvent` values into user-friendly UI strings.
struct DamageEventFormatter {
    
    /// Returns a UI display string for the given damage event.
    ///
    /// - Parameter event: The `DamageEvent` to format.
    /// - Returns: A user-facing message describing the event, or `nil` if no message is necessary.
    static func message(for event: DamageEvent) -> String? {
        switch event {
        case .allRepaired:
            return "All systems have been fully repaired."
            
        case .system(let systemEvent):
            return message(for: systemEvent)
        }
    }
    
    /// Returns a UI string describing a change to a specific ship system's damage state.
    ///
    /// - Parameter event: The `ShipSystemDamageEvent` to format.
    /// - Returns: A user-facing message or `nil` if no change occurred.
    private static func message(for event: ShipSystemDamageEvent) -> String? {
        switch event.changeType {
        case .damaged:
            return "\(event.system.displayName) has been damaged."
        case .repaired:
            if event.newDamage == 0 {
                return "\(event.system.displayName) has been repaired."
            }
            return nil // improved but not yet fully repaired
            
        case .unchanged:
            return nil // No message needed for unchanged
        }
    }
}
