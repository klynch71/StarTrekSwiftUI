//
//  LogView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

/// an autoscrolling log view
struct LogView: View {
    private var appState: AppState
    private var viewModel: LogViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.viewModel = LogViewModel(appState: appState)
    }
    
    var body: some View {
        ZStack {
            Color.black
            
           AutoScrollingView(lines: appState.log)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

#Preview {
    LogView(appState: AppState())
        
}
