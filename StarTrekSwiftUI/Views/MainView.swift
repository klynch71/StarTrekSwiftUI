//
//  MainView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    let selection: MainScreen
    var body: some View {

        switch(selection) {
        case .initial:
            InitialView()
            
        case .navigation:
            if appState.enterprise.damage.isDamaged(.engines) {
                DamagedSystemView(message: "Warp engines are damaged.")
            } else {
                NavigationView(appState: appState)
            }
            
        case .shortRangeSensors:
            if appState.enterprise.damage.isDamaged(.shortRangeScanner) {                DamagedSystemView(message: "Short range sensors have been damaged.")
            } else {
                ShortRangeSensorView(appState: appState)
                   
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
