//
//  DamageReportView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//

import SwiftUI

/*
 Display state of damaged systems
 */
struct DamageReportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            let damagedSystems = appState.enterprise.damage.damagedSystems
            
            //display the damage systems
            ForEach(damagedSystems, id: \.self) { system in
                let damageLevel = appState.enterprise.damage[system]

                Text("\(getPrefix(system)) damage level: \(damageLevel)")
            }
            
            if damagedSystems.count == 0 {
                Text("All systems are operational.")
                    .font(.title)
            }
        }
    }
    
    /*
     return text for the given system
     */
    func getPrefix(_ system: ShipSystem) ->String {
        switch (system) {
        case .engines:
            return "Engines"
        case .shortRangeScanner:
            return "Short range sensors"
        case .longRangeScanner:
            return "Long range snesors"
        case .shieldControl:
            return "Shield control"
        case .photons:
            return "Photon torpedoes"
        case .computer:
            return "Computer"
        case .phasers:
            return "Phasers"
        }
    }
}

#Preview {
    DamageReportView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
