//
//  ConditionView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

struct ConditionView: View {
    @EnvironmentObject var model: AppState
    @State var audioPlayer = AudioPlayer()
    
    var body: some View {

            Image(getImageName())
            .resizable()
            .scaledToFit()
            .onTapGesture {audioPlayer.stop()}
    }
    
    /*
     return the appropriate imageName based on
     current conditions
     */
    func getImageName() -> String {
        switch model.enterprise.condition {
        case .docked:
            audioPlayer.stop()
            return "Docked"
        case .alert:
           // audioPlayer.play("redAlert.wav", loops: -1)
            return "RedAlert"
        case .caution:
            audioPlayer.stop()
            return "ConditionYellow"
        case .green:
            audioPlayer.stop()
            return "ConditionGreen"
        }
    }
}

#Preview {
    ConditionView()
        .preferredColorScheme(.dark)
        .environmentObject(AppState())
}
