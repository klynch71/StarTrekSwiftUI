//
//  StatusView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/14/25.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var model: AppState

    var body: some View {
        VStack {
            HStack {
                Text("Energy: \(String(Int(model.enterprise.freeEnergy)))")
                Spacer()
                Text(location())
                Spacer()
                Text("Stardate: \(String(model.starDate))")
                ConditionView()
            }
        }
    }
    
    func location() -> String {
        guard let quadrant = model.enterprise.location.quadrant,
              let gridPos = model.enterprise.location.gridPosition()
        else {
            return "Unknown"
        }
        let name = quadrant.name

        return "\(name) (\(gridPos.qX), \(gridPos.qY)), Sector: (\(gridPos.sX), \(gridPos.sY))"
    }
}

#Preview {
    StatusView()
        .environmentObject(AppState())
}
