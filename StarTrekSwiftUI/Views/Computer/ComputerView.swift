//
//  ComputerView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

struct ComputerView: View {
    var body: some View {
        CustomTabView(
            content: [
                (
                    title: "Galactic Record",
                    icon: "GalacticRecord",
                    view: AnyView (
                        GalaticRecordView()
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
                    title: "StarBase Nav",
                    icon: "StarBaseNav",
                    view: AnyView (
                        StarBaseNavView()
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
                            VStack {
                                Image("Galaxy")
                                    .resizable()
                            }.opacity(0.3)

                            GalaxyGridView()
                        }
                    )
                )
            ])
    }
}


#Preview {
    ComputerView()
}
