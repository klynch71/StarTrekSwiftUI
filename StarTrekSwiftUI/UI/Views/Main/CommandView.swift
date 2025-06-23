//
//  CommandView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/31/25.
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
            Button("Short Range Scan", action: shortRangeSensors)
            Spacer()
            Button("Long Range Scan", action: {longRangeSensors(appState: appState)})
            Spacer()
            Button("Damage Report", action: damageReport)
            Spacer()
            Button("Computer", action: computer)
            Spacer()
        }
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

