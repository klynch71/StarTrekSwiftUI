//
//  ContentView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/10/25.
//

import SwiftUI

enum WindowType {
    case initial
    case navigation
    case shortRangeSensors
    case longRangeSensors
    case log
    case computer
}

struct ContentView: View {
    @EnvironmentObject var model: AppState
    @State var activeWindow: WindowType = .initial
    
    var body: some View {
        VStack {
            StatusView()
                .frame(height: 20)
            HStack {
                NavigationView()
                    .frame(width: 80)
                MainView(selection: activeWindow)
                ShieldView(shields: $model.enterprise.shields, maxRange: model.enterprise.energy)
                    .frame(width: 80)
                TorpedoView()
                    .frame(width: 80)
                PhaserView()
                    .frame(width: 80)
                    .accentColor(Color.red)
            }
            MessageView(message: $model.message)
                .padding(.bottom)
            ControlView(selection: $activeWindow)
        }
        .padding()
    }

}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
