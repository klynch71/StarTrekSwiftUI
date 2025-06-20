//
//  PhaserView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//

import SwiftUI

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
            Button("Fire", action: {fire(appState.enterprise.phaserEnergy, appState: appState)})
                .background(Color.red)
                .padding(.vertical)
        }
        .disabled(appState.enterprise.damage.isDamaged(.phaserControl))
    }
    
    ///fire phasers with the given energy
    func fire (_ energy: Int, appState: AppState) {
        commandExecutor.firePhasers(phaserEnergy: energy)
    }
}

#Preview {
    PhaserView(appState: AppState())
        .preferredColorScheme(.dark)
}
