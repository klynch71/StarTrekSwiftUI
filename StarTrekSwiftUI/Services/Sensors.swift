//
//  Sensors.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/11/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

/// Sensors represent the short-range and long-range sensor systems aboard the Enterprise.
struct Sensors {
    let appState: AppState
    
    /// Activates the short-range sensors for the Enterprise.
    ///
    /// This marks the current quadrant as explored and updates the sensor status.
    func shortRangeScan() {
        let currentQuadrant = appState.enterprise.location.quadrant
        appState.updateEnterprise {$0.exploredSpace.insert(currentQuadrant) }
        appState.updateEnterprise {$0.sensorStatus = .shortRangeOn}
    }
    
    /// Activates the long-range sensors for the Enterprise.
    ///
    /// This marks all valid adjacent quadrants as explored and updates the sensor status.
    func longRangeScan() {
        let quadrants = appState.adjacentQuadrants().compactMap {$0}
        appState.updateEnterprise { $0.exploredSpace.formUnion(quadrants)}
        appState.updateEnterprise {$0.sensorStatus = .longRangeOn}
    }
}
