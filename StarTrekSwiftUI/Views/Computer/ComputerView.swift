//
//  ComputerView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

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
                        MetricCalculatorView()
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
                //every use of the computer induces a change for damage
                if let message = damageControl.handleDamageOrRepair(system: .computer) {
                    appState.log.append(message)
                }
                })
    }
}


#Preview {
    ComputerView(appState: AppState())
    
}
