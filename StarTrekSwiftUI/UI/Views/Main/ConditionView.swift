//
//  ConditionView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

/// Displays a visual representation of the ship's condition (e.g., Docked, Red Alert).
/// Tapping the image stops any ongoing alert sound.
struct ConditionView: View {
    @EnvironmentObject var model: AppState
    @State var audioPlayer = AudioPlayer()
    
    var body: some View {
            Image(imageName())
            .resizable()
            .scaledToFit()
            .onTapGesture {audioPlayer.stop()}
            .onChange(of: model.enterprise.condition) { _, newCondition in
                switch newCondition {
                case .alert:
                    // Uncomment to enable
                    // audioPlayer.play("redAlert.wav", loops: -1)
                    break
                default:
                    audioPlayer.stop()
                }
            }
    }
    
    /// Returns the appropriate image name based on the current ship condition.
    private func imageName() -> String {
        switch model.enterprise.condition {
        case .docked: return "Docked"
        case .alert: return "RedAlert"
        case .caution: return "ConditionYellow"
        case .green: return "ConditionGreen"
        }
    }
}

#Preview {
    ConditionView()
        .preferredColorScheme(.dark)
        .environmentObject(AppState())
}
