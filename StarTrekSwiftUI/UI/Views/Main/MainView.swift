//
//  MainView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// the  central view in the game
struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    let selection: MainScreen
    var body: some View {

        switch(selection) {
        case .initial:
            InitialView()
            
        case .shortRangeSensors:
            if appState.enterprise.damage.isDamaged(.shortRangeScanner) {                DamagedSystemView(message: "Short range sensors have been damaged.")
            } else {
                ShortRangeSensorView(viewModel: ShortRangeSensorViewModel(appState: appState))
            }
            
        case .longRangeSensors:
            if appState.enterprise.damage.isDamaged(.longRangeScanner) {                DamagedSystemView(message: "Long range sensors have been damaged.")
            } else {
                ZStack {
                    Image("Galaxy")
                        .resizable()
                        .opacity(0.3)
                    LongRangeSensorView(appState: appState)
                }
            }
            
        case .damageReport:
            ZStack {
                Image("LCARS")
                    .resizable()
                    .opacity(0.2)
                DamageReportView()
            }
            
        case .computer:
            if appState.enterprise.damage.isDamaged(.computer) {
                DamagedSystemView(message: "The computer has been damaged.")
            } else {
                ComputerView(appState: appState)
            }
        }
    }
}

#Preview {
    MainView(selection: .computer)
        .environmentObject(AppState())
}
