//
//  GameOverView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let imageName = appState.gameStatus == .lostEnterpriseDestroyed ? "EnterpriseDestroyed" : "EnterpriseLarge"
        
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
                        .padding(.vertical)
                }
            }

        } bottom: {
            LogView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /*
     star a new game
     */
    func resetGame() {
        appState.resetGame()
    }
}

#Preview {
    GameOverView()
        .environmentObject(AppState())
}
