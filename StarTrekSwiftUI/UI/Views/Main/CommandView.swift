//
//  CommandView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// A view that contains buttons to trigger commands such as Short Range Scan, Long Range Scan,
/// Damage Report, and Computer
struct CommandView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selection: MainScreen
    let commandExecutor: CommandExecutor
    
    /// Initializes the view with the app state and screen binding
    /// - Parameters:
    ///   - appState: The global application state
    ///   - selection: Binding to the currently selected main screen
    init(appState: AppState, selection: Binding<MainScreen>) {
        self._selection = selection
        self.commandExecutor = CommandExecutor(appState: appState)
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: shortRangeSensors)
                {Text("Short Range Scan")}
            Spacer()
            Button(action: {longRangeSensors(appState: appState)})
                {Text("Long Range Scan")}
            Spacer()
            Button(action: damageReport)
                {Text("Damage Report")}
            Spacer()
            Button(action: computer) {Text("Computer")}
            Spacer()
        }.padding(.top, 6)
    }
    
    //Show the short range sensors view
    func shortRangeSensors() {
        commandExecutor.shortRangeSensors()
        selection = .shortRangeSensors
    }
    
    //Show the long range sensors view
    func longRangeSensors(appState: AppState) {
        commandExecutor.longRangeSensors()
        selection = .longRangeSensors
    }
    
    //Show the damage report view
    func damageReport() {
        commandExecutor.damageReport()
        
        selection = .damageReport
    }
    
    //Show the computer view
    func computer() {
        commandExecutor.computer()
        
        selection = .computer
    }
}

#Preview {
    CommandView(appState: AppState(), selection: .constant(.initial))
        .environmentObject(AppState())
}

