//
//  TorpedoDataView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

/// Displays targeting data for Klingons in the current quadrant, including their position,
/// distance, and firing course. Shows a message if no enemies are detected.
struct TorpedoDataView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let quadrant = appState.enterprise.location.quadrant
        let enemies = appState.objects(ofType: Klingon.self, in: quadrant)
        
        ZStack {
            // Subtle LCARS-style background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
                
            VStack {
                ForEach(enemies) {enemy in
                    Text(enemyWarning(enemy))
                        .font(.title)
                }
            
                if enemies.isEmpty {
                    Text("No enemies detected in current quadrant, sir.")
                        .font(.title)
                }
            }
        }
    }
    
    /// Returns a formatted targeting string for a Klingon.
    /// Includes sector coordinates, course (degrees), and distance.
    func enemyWarning(_ enemy: any Locatable) -> String {
        let course = appState.enterprise.location.course(to: enemy.location)
        let distance = appState.enterprise.location.distance(to: enemy.location)
        
        let strSector = LocationFormatter.localSector(enemy.location)
        let strCourse = String(format: "%.1f°", course.degrees)
        let strDistance = String(format: "%.1f", distance)
        
        return "Klingon at sector \(strSector), course: \(strCourse), distance: \(strDistance)"
    }
}

#Preview {
    TorpedoDataView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
