//
//  StatusBarView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/3/25.
//

import SwiftUI

///a top banner view that displays free energy, the current location of the enterprise,  the current startdate,
///and an icon for the current condition of the ship (eg.: green, alert, docked, etc.)
struct StatusBarView: View {
    @ObservedObject var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }

    var body: some View {
        VStack {
            HStack {
                Text("Energy: \(String(Int(appState.enterprise.freeEnergy)))")
                Spacer()
                Text(location())
                Spacer()
                Text("Stardate: \(String(format: "%.1f", appState.starDate))")
                ConditionView()
            }
        }
    }
    
    func location() -> String {
        let loc = appState.enterprise.location
        let name = loc.quadrant.name

        return "\(name) (\(loc.qX), \(loc.qY)), Sector: (\(loc.sX), \(loc.sY))"
    }
}

#Preview {
    StatusBarView(appState: AppState())
        .environmentObject(AppState())
}

