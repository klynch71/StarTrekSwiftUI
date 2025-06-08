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
        
        ZStack {
            //computer background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
                
            VStack {
                let enemies = getEnemies()
                let indices = Array(0..<enemies.count)
                ForEach (indices, id:\.self) {index in
                    Text(enemyWarning(enemies[index]))
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
     return an array of Sectors containing enemies
     in the current quadrant
     */
    func getEnemies() -> [Locatable] {
        let ourQuadrant = appState.enterprise.location.quadrant
        let sectorObjects = appState.galaxyObjects.filter {$0.location.quadrant == ourQuadrant}
        return sectorObjects.filter {$0 is Klingon}
    }
    
    /*
     return text for the given enemy object
     */
    func enemyWarning(_ enemy: Locatable) -> String {
        guard let pos = enemy.location.gridPosition()else {
            return "Computer Error: Unknown Enemy Position."
        }
        let course = appState.enterprise.location.course(to: enemy.location)
        let distance = appState.enterprise.location.distance(to: enemy.location)
        
        let s = "Direction: \(String(format: "%.1f", course.degrees)) Klingon at Sector (\(pos.sX),\(pos.sY)), distance: \(String(format: "%.1f", distance))"
        
        return s
    }
}

#Preview {
    TorpedoDataView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
