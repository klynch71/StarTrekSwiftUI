//
//  PhaserView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//

import SwiftUI

struct PhaserView: View {
    @EnvironmentObject var model: AppState
    @State private var phaserEnergy: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Phasers:")
                .padding(.top)
                .frame(alignment: .center)
            Text(String(Int(phaserEnergy)))
                .frame(alignment: .center)
            VerticalSlider(
                value: $phaserEnergy,
                in: 0...model.enterprise.freeEnergy,
                step: 1.0
            )
            .frame(minWidth: 40, minHeight:200)
            Button("Fire", action: fire)
                .background(Color.red)
                .padding(.vertical)
            
        }
    }
    
    /*
     fire Phasers
     */
    func fire () {
        
    }
}

#Preview {
    PhaserView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
