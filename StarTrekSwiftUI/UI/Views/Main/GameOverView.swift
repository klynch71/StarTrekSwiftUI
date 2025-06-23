//
//  GameOverView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//

import SwiftUI

/// a view that shows why the game is over (e.g. loss due to being destroyed or ran out of time, won, etc)
struct GameOverView: View {
    @EnvironmentObject var appState: AppState
    private var imageName: String {
        appState.gameStatus == .lostEnterpriseDestroyed ? "EnterpriseDestroyed" : "EnterpriseLarge"
    }
    
    var body: some View {
        
        VerticalSplitView(topHeightRatio: 0.75) {
            ZStack {
                Color.black
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.6)
                
                VStack {
                    Spacer()
                    Text(appState.gameStatus.message)
                        .font(.title)
                    Spacer()
                    Button("Reset", action: resetGame)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }

        } bottom: {
            LogView(appState: appState)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Start a new game.
    func resetGame() {
        appState.resetGame()
    }
}

#Preview {
    GameOverView()
        .environmentObject(AppState())
}
