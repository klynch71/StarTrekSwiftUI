//
//  StatusBarView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/3/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
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
        let strQuadrant = LocationFormatter.quadrant(loc)
        let strSector = LocationFormatter.localSector(loc)

        return "\(name) \(strQuadrant), Sector: \(strSector)"
    }
}

#Preview {
    StatusBarView(appState: AppState())
        .environmentObject(AppState())
}

