//
//  StarbaseNavView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// provides course and distance to any starBases in the current quadrant.
struct StarbaseNavView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let quadrant = appState.enterprise.location.quadrant
        let Starbases = appState.objects(ofType: Starbase.self, in: quadrant)
        ZStack {
            //computer background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
            
            //directions to Starbase
            VStack(alignment: .leading) {
                ForEach (Starbases) { Starbase in
                    let navData = appState.enterprise.location.navigate(to: Starbase.location)
                    let strLocation = LocationFormatter.localSector(Starbase.location)
                    let strDirection = String(format: "%1.f°", navData.course.degrees)
                    let strDistance = String(format: "%1.f", navData.distance)
                        
                    Text("Starbase in sector: \(strLocation)")
                    Text("  course: \(strDirection)")
                    Text("  distance: \(strDistance)")
                }
                
                if Starbases.count == 0 {
                    Text("There are no Starbases in this quadrant.")
                }
            }.font(.title)
        }
    }
}

#Preview {
    StarbaseNavView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
