//
//  GameIntroFormatter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/24/25.
//

import Foundation

/// provides details of the goals of the game including number of Klingons to destroy, how many starBases are available and the time allotted
/// for the mission
struct GameIntroFormatter {
    static func missionBriefing(starDateEnd: Double, timeRemaining: Double, klingons: Int, starbases: Int) -> String {
        let base = "USS Enterprise, your orders are as follows:\n"
        let mission = "Destroy the \(klingons) Klingon warships which have invaded the Galaxy before they can attack Federation headquarters on stardate \(String(starDateEnd))."
        let time = "This gives you \(timeRemaining) stardates."
        let baseCount = "There \(starbases > 1 ? "are" : "is") \(starbases) Starbase\(starbases > 1 ? "s" : "") in the Galaxy for resupplying your ship."

        return "\(base)\(mission) \(time) \(baseCount)"
    }
}
