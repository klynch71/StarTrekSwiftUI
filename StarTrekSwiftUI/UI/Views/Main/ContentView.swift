//
//  ContentView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/10/25.
//

import SwiftUI

///Window to display in the main viewing area.
enum MainScreen {
    case initial
    case shortRangeSensors
    case longRangeSensors
    case damageReport
    case computer
}

/// The application view that contains all other views.
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State var activeMainScreen: MainScreen = .initial
    
    var body: some View {
        VStack {
            if appState.gameStatus.isGameOver {
                GameOverView()
            } else {
                StatusBarView(appState: appState)
                    .frame(height: 20)
                HStack {
                    NavigationView(appState: appState)
                        .frame(width: 80)
                    VerticalSplitView(topHeightRatio: 0.75) {
                        MainView(selection: activeMainScreen)
                    } bottom: {
                        LogView(appState: appState)
                    }
                    ShieldView(appState: appState)
                        .padding(.bottom, 60)
                        .frame(width: 80)
                    TorpedoView(appState: appState)
                        .frame(width: 80)
                    PhaserView(appState: appState)
                        .frame(width: 80)
                        .accentColor(Color.red)
                }
                CommandView(appState: appState, selection: $activeMainScreen)
                    .padding(.top)
            }
        }
        .padding()
        .onChange(of: appState.gameStatus) { _, newStatus in
            if newStatus == .starting {
                activeMainScreen = .initial
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
