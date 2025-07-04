//
//  ComputerView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// the main computer view with a tab that allows the user to access different computer functions:
/// GalacticRecord, StatusReport, Torpedo Data, etc.
struct ComputerView: View {
    let appState: AppState
    let damageControl: DamageControl
    
    init(appState: AppState) {
        self.appState = appState
        self.damageControl = DamageControl(appState: appState)
    }
    
    var body: some View {
        CustomTabView(
            content: [
                (
                    title: "Galactic Record",
                    icon: "GalacticRecord",
                    view: AnyView (
                        ZStack {
                            Image("Galaxy")
                                .resizable()
                                .opacity(0.3)
                            
                            GalacticRecordView(appState: appState)
                        }
                    )
                ),
                (
                    title: "Status Report",
                    icon: "Report",
                    view: AnyView(
                        StatusReportView()
                    )
                ),
                (
                    title: "Torpedo Data",
                    icon: "Torpedo",
                    view: AnyView (
                        TorpedoDataView()
                    )
                ),
                (
                    title: "Starbase Nav",
                    icon: "StarbaseNav",
                    view: AnyView (
                        StarbaseNavView()
                    )
                ),
                (
                    title: "Calculator",
                    icon: "Distance",
                    view: AnyView(
                        MetricCalculatorView(viewModel: ShortRangeSensorViewModel(appState: appState))
                    )
                ),
                (
                    title: "Galaxy Map",
                    icon: "Map",
                    view: AnyView(
                        ZStack {
                            Image("Galaxy")
                                .resizable()
                                .opacity(0.3)
                            
                            GalaxyMapView()
                        }
                    )
                )
            ],
            onTabWillChange: { _ in
                //every use of the computer induces a chance for damage
                damageControl.handleDamageOrRepair(system: .computer)
            })
    }
}


#Preview {
    ComputerView(appState: AppState())
    
}
