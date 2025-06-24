//
//  DamageReportView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// Displays the state of damaged systems aboard the Enterprise.
struct DamageReportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let damagedSystems = appState.enterprise.damage.damagedSystems
        
        VStack {
            //display the damage systems
            ForEach(damagedSystems, id: \.self) { system in
                let damageLevel = appState.enterprise.damage[system]

                Text("\(getPrefix(system)) damage level: \(damageLevel)")
                    .monospacedDigit()
            }
            
            if damagedSystems.isEmpty {
                Text("All systems are operational.")
                    .font(.title)
            }
        }
    }
    
    /// Returns a user-friendly name for the given ship system.
    func getPrefix(_ system: ShipSystem) ->String {
        switch (system) {
        case .engines:
            return "Engines"
        case .shortRangeScanner:
            return "Short range sensors"
        case .longRangeScanner:
            return "Long range sensors"
        case .shieldControl:
            return "Shield control"
        case .torpedoControl:
            return "Photon torpedoes"
        case .computer:
            return "Computer"
        case .phaserControl:
            return "Phasers"
        }
    }
}

#Preview {
    DamageReportView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
