//
//  ShieldView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/19/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

///The view for displaying and setting Shield strength.
///
struct ShieldView: View {
    @ObservedObject var appState: AppState
    
    // Computed binding for shieldEnergy
    private var shieldEnergyBinding: Binding<Int> {
        Binding<Int>(
            get: { appState.enterprise.shieldEnergy },
            set: { newValue in
                appState.updateEnterprise { $0.shieldEnergy = newValue }
            }
        )
    }
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    var body: some View {
        VStack {
            //Control for setting Shield energy
            DrainSlider(
                drain: shieldEnergyBinding,
                totalResource: appState.enterprise.totalEnergy,
                competingDrains: { [appState.enterprise.phaserEnergy] },
                label: "Shields"
            )
            .disabled(appState.enterprise.damage.isDamaged(.phaserControl))
        }
    }
}

