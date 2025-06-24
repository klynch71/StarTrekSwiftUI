//
//  PhaserView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// Provides controls for setting phaser energy and firing phasers.
struct PhaserView: View {
    @ObservedObject var appState: AppState
    private let commandExecutor: CommandExecutor
    
    // Computed binding for phaserEnergy
    private var phaserEnergyBinding: Binding<Int> {
        Binding<Int>(
            get: { appState.enterprise.phaserEnergy },
            set: { newValue in
                appState.updateEnterprise { $0.phaserEnergy = newValue }
            }
        )
    }
    
    init(appState: AppState) {
        self.appState = appState
        self.commandExecutor = CommandExecutor(appState: appState)
    }
    
    var body: some View {
        VStack {
            //Control for setting Phaser energy
            DrainSlider(
                drain: phaserEnergyBinding,
                totalResource: appState.enterprise.totalEnergy,
                competingDrains: { [appState.enterprise.shieldEnergy] },
                label: "Phasers"
            )
        
            //fire button
            Button("Fire", action: {fire(appState.enterprise.phaserEnergy)})
                .background(Color.red)
                .padding(.vertical)
        }
        .disabled(appState.enterprise.damage.isDamaged(.phaserControl))
    }
    
    ///fire phasers with the given energy
    func fire (_ energy: Int) {
        commandExecutor.firePhasers(phaserEnergy: energy)
    }
}

#Preview {
    PhaserView(appState: AppState())
        .preferredColorScheme(.dark)
}
