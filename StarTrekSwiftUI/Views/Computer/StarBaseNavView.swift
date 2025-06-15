//
//  StarbaseNavView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

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
                    let pos = Starbase.location
                    let navData = appState.enterprise.location.navigate(to: Starbase.location)
                    let strDirection = String(format: "%1.f", navData.course.degrees)
                    let strDistance = String(format: "%1.f", navData.distance)
                        
                    Text("Starbase in sector: (\(pos.sX), \(pos.sY))")
                    Text("course: \(strDirection)")
                    Text("distance: \(strDistance)")
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
