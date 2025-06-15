//
//  TorpedoDataView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

struct TorpedoDataView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let quadrant = appState.enterprise.location.quadrant
        let enemies = appState.objects(ofType: Klingon.self, in: quadrant)
        
        ZStack {
            //computer background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
                
            VStack {
                ForEach(enemies) {enemy in
                    Text(enemyWarning(enemy))
                        .font(.title)
                }
            
                if enemies.count == 0 {
                    Text("No enemies detected in current quadrant, sir.")
                        .font(.title)
                }
            }
        }
    }
    
    /*
     return text for the given enemy object
     */
    func enemyWarning(_ enemy: any Locatable) -> String {
        let pos = enemy.location
  
        let course = appState.enterprise.location.course(to: enemy.location)
        let distance = appState.enterprise.location.distance(to: enemy.location)
        
        let strSector = "(\(pos.sX),\(pos.sY))"
        let strCourse = String(format: "%.1f", course.degrees)
        let strDistance = String(format: "%.1f", distance)
        
        return "Klingon at sector \(strSector), course: \(strCourse), distance: \(strDistance)"
    }
}

#Preview {
    TorpedoDataView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
