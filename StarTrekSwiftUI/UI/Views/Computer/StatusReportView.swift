//
//  StatusReportView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

/// Displays the status of the game in terms of remaining klingons, number of starbases, and remaining
/// time to complete the mission.
struct StatusReportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let klingons = appState.objects(ofType: Klingon.self).count
        let Starbases = appState.objects(ofType: Starbase.self).count
        let strTimeRemaining = String(format: "%.1f", appState.timeRemaining)
        let timeS = appState.timeRemaining > 1 ? "s" : ""
        let timeSB = Starbases > 1 ? "s" : ""

        ZStack {
            //computer background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
            
            //status
            VStack {
                Text("There are \(klingons) Klingon ships remaining in the Galaxy.")
                
                Text("The Federation is maintaing \(Starbases) Starbase\(timeSB) in the Galaxy.")
                
                Text("You have \(strTimeRemaining) stardate\(timeS) remaining.")
            }.font(.title)
        }
    }
}

#Preview {
    StatusReportView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
